{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nvf.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "henrik"
  ];
  nixpkgs.config.allowUnfree = true;
  system.nixCache.enable = true;

  system.remoteBuild = {
    enable = true;
    hostName = "192.168.10.62";
    hostPublicKeyFile = ../../keys/nix-cache-host.pub;
    sshUser = "henrik";
    sshKey = "/home/henrik/.ssh/nix-build";
    maxJobs = 4;
    speedFactor = 2;
  };
  system.stateVersion = "25.11";

  # Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_7_0;
    # kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "sd_mod"
    ];
  };

  # Networking
  networking = {
    hostName = "nixos-personal";
    networkmanager.enable = true;
  };

  # Locale & keyboard
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "no";
    variant = "nodeadkeys";
  };
  console.keyMap = "no";

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.henrik = {
    isNormalUser = true;
    description = "Henrik Strocka";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    fastfetch
    alejandra
    gcc
    file
    ripgrep
    prusa-slicer
    inputs.hyprsession.packages.${pkgs.system}.default
  ];

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    nix-index-database.comma.enable = true;

    nix-ld.enable = true;
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.henrik = import ./_home/home.nix;
    backupFileExtension = "backup";
  };

  # Services
  services.printing.enable = true;
  services.openssh.enable = true;

  services.networkStorage = {
    enable = true;
    mounts.share = {
      device = "192.168.10.196:/mnt/HDD16/Share";
      mountPoint = "/mnt/s";
      options = [
        "rw"
        "nolock"
      ];
    };

    mounts.llm = {
      device = "192.168.10.196:/mnt/HDD16/LLM";
      mountPoint = "/mnt/llm";
      options = [
        "rw"
        "nolock"
      ];
    };
  };

  services.llm = {
    enable = true;
    modelsDir = "/mnt/llm/models/";
    acceleration = "cuda";
    contextSize = 16384;
    extraArgs = ["--flash-attn on"];
  };

  services.gaming = {
    enable = true;
    extraUsers = ["henrik"];
  };

  services.environments.dotnet = {
    enable = true;
    sdks = [ pkgs.dotnet-sdk_9 pkgs.dotnet-sdk_11 ];
  };

  # Filesystems
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/9CF4C5D4F4C5B136";
    fsType = "ntfs";
  };

  fileSystems."/mnt/old" = {
    device = "/dev/disk/by-uuid/0886AA3186AA1F66";
    fsType = "ntfs";
  };
}
