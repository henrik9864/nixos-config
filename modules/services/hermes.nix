{ inputs, ... }:
{
  flake.modules.nixos.hermes = { config, lib, pkgs, ... }: let
    cfg = config.services.hermes;
  in {
    options.services.hermes = {
      enable = lib.mkEnableOption "Hermes Agent (Nous Research self-improving AI agent) gateway";
      package = lib.mkOption {
        type = lib.types.package;
        default = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;
        defaultText = lib.literalExpression "inputs.hermes-agent.packages.\${pkgs.stdenv.hostPlatform.system}.default";
        description = "The hermes-agent package.";
      };
      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/hermes";
        description = "State directory for Hermes.";
      };
      extraEnv = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Extra environment variables to pass to the service.";
      };
    };
    config = lib.mkIf cfg.enable {
      assertions = [
        { assertion = config.services.llm.enable; message = "services.hermes requires services.llm"; }
      ];
      users.users.hermes = { isSystemUser = true; group = "hermes"; home = cfg.dataDir; };
      users.groups.hermes = {};
      systemd.services.hermes = {
        description = "Hermes Agent messaging gateway";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" "llama-cpp.service" ];
        wants = [ "network-online.target" "llama-cpp.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.dbus}/bin/dbus-run-session -- ${cfg.package}/bin/hermes gateway start";
          Environment =
            [
              "HOME=${cfg.dataDir}"
              "OPENAI_API_BASE_URL=http://${config.services.llm.host}:${toString config.services.llm.port}/v1"
              "OPENAI_API_KEY=sk-dummy"
            ]
            ++ lib.mapAttrsToList (n: v: "${n}=${v}") cfg.extraEnv;
          User = "hermes";
          Group = "hermes";
          Restart = "on-failure";
          RestartSec = 5;
          WorkingDirectory = cfg.dataDir;
          StateDirectory = "hermes";
        };
      };
      environment.systemPackages = [ cfg.package ];
    };
  };
}
