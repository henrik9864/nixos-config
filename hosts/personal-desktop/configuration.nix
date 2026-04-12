{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  services.xserver.xkb = {
    layout = "no";
    variant = "nodeadkeys";
  };
  console.keyMap = "no";

  services.printing.enable = true;

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
    packages = with pkgs; [ ];
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    inputs.hyprsession.packages.${pkgs.system}.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.henrik = import ./_home/home.nix;
    backupFileExtension = "backup";
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = true;
      vim.theme.name = "gruvbox";
      vim.theme.style = "dark";
      vim.theme.transparent = true;

      vim.statusline.lualine.enable = true;
      vim.autocomplete.nvim-cmp.enable = true;
      vim.filetree.neo-tree.enable = true;

      vim.globals = {
        mapleader = " ";
        shell = "${pkgs.zsh}/bin/zsh";
        shellcmdflag = "-ic";
      };

      vim.options = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        expandtab = true;
        smartindent = true;
      };

      vim.keymaps = [
        {
          key = "<leader>e";
          mode = [ "n" ];
          silent = true;
          action = ":Neotree toggle<CR>";
        }
        {
          key = "<leader>cc";
          mode = [ "n" ];
          silent = true;
          action = ":CodeCompanionChat toggle<CR>";
        }
      ];

      vim.lsp.enable = true;
      vim.treesitter.enable = true;

      vim.languages = {
        nix.enable = true;
      };

      vim.assistant.copilot.enable = true;
      vim.assistant.codecompanion-nvim = {
        enable = true;
        setupOpts = {
          adapters = lib.generators.mkLuaInline ''
            {
              ollama = require("codecompanion.adapters").extend("ollama", {
                schema = { model = { default = "gemma4:e4b" } },
              }),
              copilot = require("codecompanion.adapters").extend("copilot", {}),
            }
          '';
          strategies = lib.generators.mkLuaInline ''
            { chat = { adapter = "copilot" }, inline = { adapter = "copilot" } }
          '';
        };
      };
    };
  };

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
      "gemma4:26b"
      "gemma4:e4b"
    ];
    extraUsers = [ "henrik" ];
  };

  services.gaming = {
    enable = true;
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
