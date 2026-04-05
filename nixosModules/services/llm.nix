{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.llm;
in
{
  options.services.llm = {
    enable = lib.mkEnableOption "Local LLM service via Ollama";

    acceleration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "rocm"
          "cuda"
          "vulkan"
        ]
      );
      default = "cuda";
      description = ''
        Hardware acceleration backend.
        Use "cuda" for NVIDIA GPUs, "rocm" for AMD GPUs, "vulkan" for generic GPU, or null for CPU only.
      '';
      example = "rocm";
    };

    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of Ollama models to pull and keep available on activation.
        These can be standard Ollama models (e.g. "llama3.2") or HuggingFace
        GGUF models using the hf.co/ prefix (e.g. "hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF").
      '';
      example = [
        "llama3.2"
        "hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF"
      ];
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address Ollama listens on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 11434;
      description = "Port Ollama listens on.";
    };

    extraUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional users to give access to the ollama group.";
      example = [ "henrik" ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = cfg.acceleration;
      host = cfg.host;
      port = cfg.port;
      loadModels = cfg.models;
    };

    environment.systemPackages = [
      pkgs.oterm
      pkgs.ollama
    ];

    users.users = lib.mkMerge (
      map (user: {
        ${user}.extraGroups = [ "ollama" ];
      }) cfg.extraUsers
    );
  };
}
