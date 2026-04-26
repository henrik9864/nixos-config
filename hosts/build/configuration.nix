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

  system.sshKeys.enable = true;
  system.nixCache.enable = true;

  system.remoteBuild = {
    enable = true;
    hostName = "192.168.10.62";
    sshUser = "henrik";
    maxJobs = 4;
    speedFactor = 2;
  };

  system.ip = {
    enable = true;
    interface = "ens18";
    address = "192.168.10.60";
    gateway = "192.168.10.1";
  };

  time.timeZone = "Europe/Oslo";

  users.users.henrik = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
        "z"
      ];
    };
  };

  programs.zsh.shellAliases = {
    nrs = "sudo nixos-rebuild switch";
    nrsf = "sudo nixos-rebuild switch --fast";
    ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
  ];

  services.vscode-server.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
