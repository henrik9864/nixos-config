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

          options = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Additional mount options";
            example = [ "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
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

    # Generate a fileSystems entry for each mount
    fileSystems = lib.mapAttrs' (_: mount:
      lib.nameValuePair mount.mountPoint {
        device = mount.device;
        fsType = mount.fsType;
      }
      // lib.optionalAttrs (mount.options != [ ]) {
        options = mount.options;
      }
    ) cfg.mounts;
  };
}
