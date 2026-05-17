{
  config,
  lib,
  pkgs,
  pkgs-unstable ? pkgs,
  ...
}: let
  cfg = config.services.openWebui;
  llamaBaseUrl =
    if config.services.llm.enable
    then "http://${config.services.llm.host}:${toString config.services.llm.port}"
    else null;
in {
  options.services.openWebui = {
    enable = lib.mkEnableOption "Open WebUI service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs-unstable.open-webui;
      defaultText = lib.literalMD "`pkgs.unstable.open-webui`";
      description = "The open-webui package to use.";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "henrik";
      description = "User to run the Open WebUI service as.";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address Open WebUI listens on.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = "Port Open WebUI listens on.";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/open-webui";
      description = "Data directory for Open WebUI (database, uploads, etc.).";
    };
    databasePath = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/data.db";
      description = "Path to the SQLite database file.";
    };
    ollamaApiBaseUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = llamaBaseUrl;
      defaultText = lib.literalMD "Auto-detected from `services.llm` if enabled, otherwise `null`.";
      description = "URL of the Ollama/OpenAI-compatible API backend (e.g. llama.cpp server).";
    };
    extraEnv = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra environment variables to pass to the service.";
      example = lib.literalExpression ''
        {
          ANONYMIZED_TELEMETRY = "false";
          ENABLE_SIGNUP = "true";
        }
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.open-webui = {
      description = "Open WebUI";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      wants = ["network.target"];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/open-webui serve";
        Environment =
          [
            "DATA_DIR=${cfg.dataDir}"
            "HOST=${cfg.host}"
            "PORT=${toString cfg.port}"
          ]
          ++ (lib.optional (cfg.ollamaApiBaseUrl != null) "OLLAMA_BASE_URL=${cfg.ollamaApiBaseUrl}")
          ++ (lib.optionals (cfg.databasePath != "") ["DATABASE_PATH=${cfg.databasePath}"])
          ++ lib.mapAttrsToList (name: value: "${name}=${value}") cfg.extraEnv;
        Restart = "on-failure";
        User = cfg.user;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "open-webui";
      };
    };
    environment.systemPackages = [cfg.package];
  };
}
