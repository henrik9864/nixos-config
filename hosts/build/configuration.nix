# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../nixosModules/services/networkStorage.nix
      ./../../nixosModules/environments/cpp.nix
      ./../../nixosModules/environments/dotnet.nix
      ./../../nixosModules/environments/fpga.nix
      ./../../nixosModules/environments/buildroot.nix
      ./../../nixosModules/system/ip.nix
    ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Setup static ip
  system.ip = {
    enable = true;
    interface = "ens18";
    address = "192.168.10.60";
    gateway = "192.168.10.1";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable bleeding edge linux kernel
  boot.kernelPackages = pkgs.linuxPackages_testing;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable VS Code remote server
  services.vscode-server.enable = true;

  # Enable QEMU emulation during builds
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.henrik = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      nixd
    ];
  };

  # Enable zsh
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "docker" "z" "fzf" ];
    }; 
  };

  # Ensure vs code lsp works
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    usbutils
    file
    usbutils
    fzf

    # Rockchip
    libusb1
    (pkgs.rkdeveloptool.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "radxa";
        repo = "rkdeveloptool";
        rev = "master";  # or a specific commit
        hash = "sha256-kh6tQky2HBbkbY5dGd1VFDETbKm6YE1PnifFPt2lHK4=";  # nix will tell you the correct hash
      };
    }))
  ];

  # Configure NAS
  services.networkStorage = {
    enable = true;

    mounts = {
      share = {
        device = "192.168.10.196:/mnt/HDD16/Share";
        mountPoint = "/mnt/s";
        options = [ "rw" "nolock" ];
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Setup build enviroment
  services.environments.cpp = {
    enable = true;

    compiler = "gcc";
    extraPackages = with pkgs; [
      gcc-arm-embedded
    ];
  };

  services.environments.dotnet = {
    enable = true;

    sdks = with pkgs; [
      dotnet-sdk_10
      dotnet-sdk_11
    ];
  };

  services.environments.buildroot = {
    enable = true;
    extraConfig = [ ];
  };

  # Allow vs code to remote develop on this user
  # services.vscode-server.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

