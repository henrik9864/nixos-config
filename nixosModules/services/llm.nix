{
  config,
  lib,
  pkgs,
  pkgs-unstable ? pkgs,
  ...
}: let
  cfg = config.services.llm;
in {
  options.services.llm = {
    enable = lib.mkEnableOption "Local LLM service via llama.cpp";

    modelsDir = lib.mkOption {
      type = lib.types.str;
      description = "Path to models folder";
      example = "/mnt/llm/models/";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "henrik";
      description = "User to run the llama-cpp service as.";
    };

    acceleration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "rocm"
          "cuda"
          "vulkan"
          "metal"
        ]
      );
      default = "cuda";
      description = ''
        Hardware acceleration backend.
        Use "cuda" for NVIDIA GPUs, "rocm" for AMD GPUs, "vulkan" for generic GPU,
        "metal" for Apple Silicon, or null for CPU only.
      '';
      example = "rocm";
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

    gpuLayers = lib.mkOption {
      type = lib.types.int;
      default = 99;
      description = "Number of layers to offload to GPU. Set to 0 for CPU only.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments to pass to llama-server.";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      pkg = pkgs-unstable.llama-cpp.override {
        cudaSupport = cfg.acceleration == "cuda";
        rocmSupport = cfg.acceleration == "rocm";
        vulkanSupport = cfg.acceleration == "vulkan";
      };
    in {
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
              "--n-gpu-layers ${toString cfg.gpuLayers}"
              "--models-dir ${cfg.modelsDir}"
              #"--model /mnt/llm/models/Qwen3.5-9B-DeepSeek-V4-Flash-IQ4_XS.gguf"
            ]
            ++ cfg.extraArgs);
          Restart = "on-failure";
          User = cfg.user;
        };
      };

      environment.systemPackages = [pkg];
    }
  );
}
