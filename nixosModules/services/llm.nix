{
  config,
  lib,
  pkgs,
  pkgs-unstable ? pkgs,
  ...
}: let
  cfg = config.services.llm;

  cudaArchMap = {
    "rtx-3090" = "86";
    "rtx-3080" = "86";
    "rtx-3070" = "86";
    "rtx-3060" = "86";
    "rtx-4090" = "89";
    "rtx-4080" = "89";
    "rtx-4070" = "89";
    "rtx-4060" = "89";
    "rtx-2080" = "75";
    "rtx-2070" = "75";
    "rtx-2060" = "75";
    "a100" = "80";
    "a6000" = "86";
    "h100" = "90";
  };

  cudaArch =
    cudaArchMap.${cfg.gpuModel} or (
      throw "Unknown gpuModel '${cfg.gpuModel}'. Supported: ${lib.concatStringsSep ", " (lib.attrNames cudaArchMap)}"
    );

  backendCmakeFlags =
    if cfg.acceleration == "cuda"
    then [
      "-DGGML_CUDA=ON"
      "-DGGML_CUDA_ARCHITECTURES=${cudaArch}"
      "-DGGML_VULKAN=OFF"
      "-DGGML_ROCM=OFF"
      "-DGGML_METAL=OFF"
    ]
    else if cfg.acceleration == "rocm"
    then [
      "-DGGML_CUDA=OFF"
      "-DGGML_ROCM=ON"
      "-DGGML_VULKAN=OFF"
      "-DGGML_METAL=OFF"
    ]
    else if cfg.acceleration == "vulkan"
    then [
      "-DGGML_CUDA=OFF"
      "-DGGML_ROCM=OFF"
      "-DGGML_VULKAN=ON"
      "-DGGML_METAL=OFF"
    ]
    else [
      "-DGGML_CUDA=OFF"
      "-DGGML_ROCM=OFF"
      "-DGGML_VULKAN=OFF"
      "-DGGML_METAL=OFF"
    ];

  mtpArgs = lib.optionals cfg.mtp.enable [
    "--spec-type draft-mtp"
    "--spec-draft-n-max ${toString cfg.mtp.draftTokens}"
  ];

  modelArgs =
    if cfg.model != null
    then ["--model ${cfg.modelsDir}/${cfg.model}"]
    else ["--models-dir ${cfg.modelsDir}"];

in {
  options.services.llm = {
    enable = lib.mkEnableOption "Local LLM service via llama.cpp";

    version = lib.mkOption {
      type = lib.types.str;
      default = "9313";
      description = "Llama-cpp version (build number, e.g. 9181).";
    };

    srcHash = lib.mkOption {
      type = lib.types.str;
      description = "SHA256 hash for the llama.cpp source at the given version.";
      default = "sha256-nou/fobIUto9YpFqYPGovp7SUUQOT1f1sg1l06LVso8=";
    };

    npmDepsHash = lib.mkOption {
      type = lib.types.str;
      description = "SHA256 hash for the llama.cpp WebUI npm dependencies.";
      default = "sha512-A3ZDi8UnIkzLdnboi7dh0HOa8Q4NaLSBOxZ38iA9WaNfbkk4ppjlRSMbwDqlkEBz7//Ieyf7kdDStftkWAYdUg==";
    };

    modelsDir = lib.mkOption {
      type = lib.types.str;
      description = "Path to models folder.";
      example = "/mnt/llm/models";
    };

    model = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Model filename relative to modelsDir. Required when using MTP. If null, uses --models-dir auto-selection.";
      example = "Qwen3.6-27B-UD-Q5_K_XL-MTP.gguf";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "henrik";
      description = "User to run the llama-cpp service as.";
    };

    acceleration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum ["rocm" "cuda" "vulkan" "metal"]
      );
      default = "cuda";
      description = "Hardware acceleration backend.";
    };

    gpuModel = lib.mkOption {
      type = lib.types.str;
      default = "rtx-3090";
      description = "GPU model slug for CUDA compute capability. Only used when acceleration = cuda.";
      example = "rtx-4090";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address llama.cpp server listens on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port llama.cpp server listens on.";
    };

    contextSize = lib.mkOption {
      type = lib.types.int;
      default = 4096;
      description = "Context window size in tokens.";
    };

    batchSize = lib.mkOption {
      type = lib.types.int;
      default = 2048;
      description = "Logical batch size.";
    };

    ubatchSize = lib.mkOption {
      type = lib.types.int;
      default = 512;
      description = "Physical (micro) batch size.";
    };

    gpuLayers = lib.mkOption {
      type = lib.types.int;
      default = 99;
      description = "Number of layers to offload to GPU.";
    };

    flashAttn = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable flash attention.";
    };

    mtp = {
      enable = lib.mkEnableOption "Multi-Token Prediction (MTP) speculative decoding";

      draftTokens = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Number of tokens to speculatively draft per step (--spec-draft-n-max).";
      };
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments to pass to llama-server.";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      pkg =
        (pkgs-unstable.llama-cpp.override {
          cudaSupport = cfg.acceleration == "cuda";
          rocmSupport = cfg.acceleration == "rocm";
          vulkanSupport = cfg.acceleration == "vulkan";
        }).overrideAttrs (oldAttrs: {
          version = cfg.version;
          src = pkgs.fetchFromGitHub {
            owner = "ggml-org";
            repo = "llama.cpp";
            rev = "b${cfg.version}";
            hash = cfg.srcHash;
          };
          npmDeps = pkgs.fetchNpmDeps {
            src = pkgs.fetchFromGitHub {
              owner = "ggml-org";
              repo = "llama.cpp";
              rev = "b${cfg.version}";
              hash = cfg.srcHash;
            };
            sourceRoot = "source/tools/ui";
            hash = cfg.npmDepsHash;
          };
          # Upstream npmConfigHook looks for tools/server/webui which was
          # moved to tools/ui in newer builds — shim it with a symlink.
          postPatch = (oldAttrs.postPatch or "") + ''
            mkdir -p tools/server
            ln -s $PWD/tools/ui tools/server/webui
          '';
          preConfigure = oldAttrs.preConfigure or "";
          cmakeFlags =
            (oldAttrs.cmakeFlags or [])
            ++ [
              "-DGGML_NATIVE=OFF"
            ]
            ++ backendCmakeFlags;
        });
    in {
      assertions = [
        # {
        #   assertion = cfg.mtp.enable -> cfg.model != null;
        #   message = "services.llm.model must be set when services.llm.mtp.enable is true (MTP requires a specific model file, not --models-dir).";
        # }
      ];

      systemd.services.llama-cpp = {
        description = "llama.cpp HTTP server";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          ExecStart = lib.concatStringsSep " " ([
              "${pkg}/bin/llama-server"
              "--host ${cfg.host}"
              "--port ${toString cfg.port}"
              "--ctx-size ${toString cfg.contextSize}"
              "--batch-size ${toString cfg.batchSize}"
              "--ubatch-size ${toString cfg.ubatchSize}"
              "--n-gpu-layers ${toString cfg.gpuLayers}"
              "--flash-attn ${if cfg.flashAttn then "1" else "0"}"
            ]
            ++ modelArgs
            ++ mtpArgs
            ++ cfg.extraArgs);
          Restart = "on-failure";
          User = cfg.user;
        };
      };

      environment.systemPackages = [pkg];
    }
  );
}
