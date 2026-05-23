{
  config,
  lib,
  pkgs,
  pkgs-unstable ? pkgs,
  ...
}: let
  cfg = config.services.searxng;
  settingsFormat = pkgs.formats.yaml {};
  defaultSettings = {
    use_default_settings = true;
    general = {
      debug = false;
      instance_name = "SearXNG";
    };
    server = {
      bind_address = cfg.host;
      port = cfg.port;
      secret_key = "@SEARXNG_SECRET_KEY@";
      base_url = cfg.baseUrl;
      limiter = false;
      image_proxy = true;
    };
    ui.default_theme = "simple";
    search = {
      safe_search = 0;
      autocomplete = "";
      default_lang = "";
    };
    settings = {
      engines = [
        {
          name = "wikidata";
          disabled = true;
        }
      ];
    };
    enabled_plugins = [
      "Basic Calculator"
      "Hash plugin"
      "Self Information"
      "Tracker URL remover"
    ];
  };
  mergedSettings = lib.recursiveUpdate defaultSettings cfg.settings;
  settingsFile = settingsFormat.generate "settings.yml" mergedSettings;
in {
  options.services.searxng = {
    enable = lib.mkEnableOption "SearXNG service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs-unstable.searxng;
      defaultText = lib.literalMD "`pkgs-unstable.searxng`";
      description = "The searxng package to use.";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address SearXNG listens on.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "Port SearXNG listens on.";
    };
    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8082/";
      description = "Public base URL of the SearXNG instance.";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/searxng";
      description = "Data directory for SearXNG.";
    };
    secretKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the secret key used to encrypt cookies.
        If null, a random key is generated at startup and not persisted
        (sessions will be lost on restart).
      '';
    };
    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = ''
        SearXNG settings to merge on top of the defaults.
        See https://docs.searxng.org/admin/settings/index.html for available options.
      '';
      example = lib.literalExpression ''
        {
          general.instance_name = "My Search";
          search.safe_search = 1;
        }
      '';
    };
    extraEnv = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra environment variables to pass to the service.";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.searxng = {
      description = "SearXNG";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      preStart = let
        inherit (pkgs) openssl coreutils gnused;
        secretKeyScript =
          if cfg.secretKeyFile != null
          then ''KEY=$(${coreutils}/bin/cat ${lib.escapeShellArg cfg.secretKeyFile})''
          else ''KEY=$(${openssl}/bin/openssl rand -hex 32)'';
      in ''
        ${coreutils}/bin/cp ${settingsFile} ${cfg.dataDir}/settings.yml
        ${coreutils}/bin/chmod 600 ${cfg.dataDir}/settings.yml
        ${secretKeyScript}
        ${gnused}/bin/sed -i "s/@SEARXNG_SECRET_KEY@/$KEY/" ${cfg.dataDir}/settings.yml
      '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/searxng-run";
        Environment =
          ["SEARXNG_SETTINGS_PATH=${cfg.dataDir}/settings.yml"]
          ++ lib.mapAttrsToList (n: v: "${n}=${v}") cfg.extraEnv;
        Restart = "on-failure";
        DynamicUser = true;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "searxng";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = [cfg.dataDir];
      };
    };
    environment.systemPackages = [cfg.package];
  };
}
