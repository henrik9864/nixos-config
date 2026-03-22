{ config, lib, ... }:

let
  cfg = config.services.networkStorage;
in
{
  options.services.networkStorage = {
    enable = lib.mkEnableOption "network storage mounts";

    mounts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          device = lib.mkOption {
            type = lib.types.str;
            description = "The remote device path (e.g. 192.168.10.196:/mnt/HDD16/Share)";
            example = "192.168.10.196:/mnt/HDD16/Share";
          };

          mountPoint = lib.mkOption {
            type = lib.types.str;
            description = "Local mount point path";
            example = "/mnt/share";
          };

          fsType = lib.mkOption {
            type = lib.types.str;
            default = "nfs";
            description = "Filesystem type for the mount";
            example = "cifs";
          };

          automount = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether to mount lazily on first access rather than blocking boot.
              Creates a systemd .automount unit instead of mounting at boot.
            '';
          };

          idleTimeout = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = ''
              Unmount the share after this many seconds of inactivity.
              Set to null to keep it mounted indefinitely once connected.
            '';
            example = 600;
          };

          options = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Additional mount options";
            example = [ "ro" "vers=4" ];
          };
        };
      });
      default = { };
      description = "Set of network storage mounts to configure";
    };
  };

  config = lib.mkIf cfg.enable {
    # Collect all unique fsTypes and add them to supported filesystems
    boot.supportedFilesystems = lib.unique (
      lib.mapAttrsToList (_: mount: mount.fsType) cfg.mounts
    );

    # Use systemd.mounts instead of fileSystems so switch-to-configuration
    # never tries to directly start the .mount unit on rebuild
    systemd.mounts = lib.mapAttrsToList (_: mount: {
      what = mount.device;
      where = mount.mountPoint;
      type = mount.fsType;
      options = lib.concatStringsSep "," mount.options;
      # Only wanted by automount unit, not by any boot target
      wantedBy = lib.mkIf (!mount.automount) [ "multi-user.target" ];
    }) cfg.mounts;

    # For automount mounts: create a systemd.automounts entry that triggers
    # the mount on first access instead of at boot
    systemd.automounts = lib.filter (x: x != null) (
      lib.mapAttrsToList (_: mount:
        if mount.automount then {
          where = mount.mountPoint;
          wantedBy = [ "multi-user.target" ];
          automountConfig = lib.optionalAttrs (mount.idleTimeout != null) {
            TimeoutIdleSec = toString mount.idleTimeout;
          };
        } else null
      ) cfg.mounts
    );
  };
}