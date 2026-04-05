{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # ./kde-plasma.nix
    ./hyprland.nix
    ./../../nixosModules/services/networkStorage.nix
    ./../../nixosModules/services/llm.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
  ];

  networking.hostName = "nixos-personal";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";

  # Keymap
  services.xserver.xkb = {
    layout = "no";
    variant = "nodeadkeys";
  };
  console.keyMap = "no";

  # Printing
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.henrik = {
    isNormalUser = true;
    description = "Henrik Strocka";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    inputs.hyprsession.packages.${pkgs.system}.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.henrik = import ./home.nix;
    backupFileExtension = "backup";
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  services.networkStorage = {
    enable = true;

    mounts = {
      share = {
        device = "192.168.10.196:/mnt/HDD16/Share";
        mountPoint = "/mnt/s";
        options = [
          "rw"
          "nolock"
        ];
      };
    };
  };

  services.llm = {
    enable = true;
    acceleration = "cuda";
    models = [
      "llama3.2"
      # "hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF"
    ];
    extraUsers = [ "henrik" ];
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/9CF4C5D4F4C5B136";
    fsType = "ntfs";
  };

  fileSystems."/mnt/old" = {
    device = "/dev/disk/by-uuid/0886AA3186AA1F66";
    fsType = "ntfs";
  };

  system.stateVersion = "25.11";
}
