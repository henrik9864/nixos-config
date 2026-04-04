{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.docker;
in
{
  options.services.docker = {
    enable = lib.mkEnableOption "Docker container support";

    enableCompose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install docker-compose.";
    };

    storageDriver = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Docker storage driver to use (e.g. \"overlay2\"). Defaults to Docker's automatic selection.";
      example = "overlay2";
    };

    autoPrune = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Periodically prune unused Docker images, containers, and volumes.";
      };

      dates = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = "How often to run docker system prune (systemd calendar format).";
        example = "daily";
      };
    };

    extraUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of users to add to the docker group.";
      example = [ "henrik" ];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = cfg.storageDriver;

      autoPrune = {
        enable = cfg.autoPrune.enable;
        dates = cfg.autoPrune.dates;
      };
    };

    environment.systemPackages = lib.mkIf cfg.enableCompose [
      pkgs.docker-compose
    ];

    users.users = lib.mkMerge (
      map (user: {
        ${user}.extraGroups = [ "docker" ];
      }) cfg.extraUsers
    );
  };
}
