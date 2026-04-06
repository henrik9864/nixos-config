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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-build";
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

  services.vscode-server.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
