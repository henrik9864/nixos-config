{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.environments.buildroot;
in
{
  options.services.environments.buildroot = {
    enable = lib.mkEnableOption "Buildroot development environment";

    overlayDir = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Path to BR2_ROOTFS_OVERLAY directory (relative to buildroot root)";
    };

    externalTree = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Path to BR2_EXTERNAL tree, leave empty to disable";
    };

    outputDir = lib.mkOption {
      type = lib.types.str;
      default = "output";
      description = "Build output directory";
    };

    extraConfig = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra BR2 config lines appended to the defconfig";
      example = [
        "BR2_PACKAGE_DROPBEAR=y"
        "BR2_SYSTEM_DHCP=\"eth0\""
      ];
    };

    jobs = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Number of parallel build jobs. 0 = auto (nproc)";
    };

    downloadDir = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Shared download cache directory for BR2_DL_DIR, leave empty for default";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Buildroot core dependencies
      gnumake
      gcc
      binutils
      patch
      gzip
      bzip2
      perl
      cpio
      unzip
      rsync
      wget
      curl
      bc
      file
      which

      # Menuconfig
      ncurses
      pkg-config
      flex
      bison

      # Commonly needed
      python3
      openssl
      dtc
      ubootTools
    ];
  };
}
