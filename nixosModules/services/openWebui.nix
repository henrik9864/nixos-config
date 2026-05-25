{
  config,
  lib,
  pkgs,
  pkgs-unstable ? pkgs,
  ...
}: let
  cfg = config.services.openWebui;
in {
  options.services.openWebui = {
    enable = lib.mkEnableOption "Open WebUI service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs-unstable.open-webui;
      defaultText = lib.literalMD "`pkgs-unstable.open-webui`";
      description = "The open-webui package to use.";
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
      description = "Data directory for Open WebUI.";
    };
    extraEnv = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra environment variables to pass to the service.";
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.llm.enable;
        message = "services.openWebui requires services.llm";
      }
    ];
    systemd.services.open-webui = {
      description = "Open WebUI";
      wantedBy = ["multi-user.target"];
      after =
        ["network.target" "llama-cpp.service"]
        ++ lib.optional config.services.searxng.enable "searxng.service";
      wants =
        ["llama-cpp.service"]
        ++ lib.optional config.services.searxng.enable "searxng.service";
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/open-webui serve --host ${cfg.host} --port ${toString cfg.port}";
        Environment =
          [
            "DATA_DIR=${cfg.dataDir}"
            "DATABASE_PATH=${cfg.dataDir}/data.db"
            "HF_HOME=${cfg.dataDir}/hf"
            "SENTENCE_TRANSFORMERS_HOME=${cfg.dataDir}/sentence-transformers"
            "TIKTOKEN_CACHE_DIR=${cfg.dataDir}/tiktoken-cache"
            "NLTK_DATA=${cfg.dataDir}/nltk"
            "ENABLE_OLLAMA_API=false"
            "OPENAI_API_BASE_URL=http://${config.services.llm.host}:${toString config.services.llm.models.qwen27b-mtp.port}/v1"
            "OPENAI_API_KEY=sk-dummy"
          ]
          ++ lib.optionals config.services.searxng.enable [
            "ENABLE_RAG_WEB_SEARCH=true"
            "RAG_WEB_SEARCH_ENGINE=searxng"
            "SEARXNG_QUERY_URL=http://${config.services.searxng.host}:${toString config.services.searxng.port}/search?q=<query>&format=json"
          ]
          ++ lib.mapAttrsToList (n: v: "${n}=${v}") cfg.extraEnv;
        Restart = "on-failure";
        DynamicUser = true;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "open-webui";
      };
    };
    environment.systemPackages = [cfg.package];
  };
}
