{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  system.sshKeys.enable = true;
  system.nixCache.enable = true;

  networking.hostName = "nixos-docker";

  system.ip = {
    enable = true;
    interface = "ens18";
    address = "192.168.10.61";
    gateway = "192.168.10.1";
  };

  services.vscode-server.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";

  users.users.henrik = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  services.openssh.enable = true;

  services.docker = {
    enable = true;
    extraUsers = [ "henrik" ];
  };

  system.stateVersion = "25.11";
}
