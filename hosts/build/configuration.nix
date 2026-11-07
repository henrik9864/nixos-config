{config, ...}: let
  inherit (config.flake.modules) nixos;
in {
  configurations.nixos.nixos-build.module = {pkgs, ...}: {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      nixos.sshKeys
      nixos.nixCache
      nixos.ip
      nixos.zsh
      ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos-build";
    networking.networkmanager.enable = true;

    system.sshKeys.enable = true;
    system.nixCache.enable = true;
    system.zsh.enable = true;

    system.ip = {
      enable = true;
      interface = "ens18";
      address = "192.168.10.60";
      gateway = "192.168.10.1";
    };

    time.timeZone = "Europe/Oslo";

    users.users.henrik = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      packages = with pkgs; [
        tree
      ];
    };

    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
      htop
    ];

    system.stateVersion = "25.11";
  };
}
