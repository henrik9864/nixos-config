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
              Uses noauto + x-systemd.automount under the hood.
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

    # Generate a fileSystems entry for each mount
    fileSystems = lib.mapAttrs' (_: mount:
      let
        automountOptions =
          lib.optionals mount.automount [
            "noauto"
            "x-systemd.automount"
          ]
          ++ lib.optional (mount.automount && mount.idleTimeout != null)
            "x-systemd.idle-timeout=${toString mount.idleTimeout}";

        allOptions = automountOptions ++ mount.options;
      in
      lib.nameValuePair mount.mountPoint (
        {
          device = mount.device;
          fsType = mount.fsType;
        }
        // lib.optionalAttrs (allOptions != [ ]) {
          options = allOptions;
        }
      )
    ) cfg.mounts;
  };
}