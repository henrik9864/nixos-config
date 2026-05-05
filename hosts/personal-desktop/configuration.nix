{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "ahci"
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

  # Programs
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    nix-index-database.comma.enable = true;

    nix-ld.enable = true;

    nvf = {
      enable = true;
      settings = {
        vim.theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = true;
        };

        vim.statusline.lualine.enable = true;

        vim.options = {
          smartindent = false;
          shiftwidth = 2;
          tabstop = 2;
          whichwrap = "b,s,<,>,[,],h,l";
        };

        vim.keymaps = [
          {
            key = "<leader>e";
            mode = ["n"];
            silent = true;
            action = ":Neotree toggle<CR>";
            desc = "Toggle file tree";
          }
          {
            key = "<leader>f";
            mode = ["n"];
            silent = true;
            action = ":w<bar>!alejandra %<CR>";
            desc = "Format Nix file with alejandra";
          }
          {
            key = "<leader>r";
            mode = ["n"];
            silent = true;
            action = ":Telescope find_files<CR>";
            desc = "Find files";
          }
          {
            key = "<leader>cc";
            mode = ["n"];
            silent = true;
            action = ":CodeCompanionChat toggle<CR>";
            desc = "Toggle CodeCompanion chat";
          }
          {
            key = "<C-Left>";
            mode = ["n"];
            silent = true;
            action = ":vertical resize -2<CR>";
            desc = "Resize split left";
          }
          {
            key = "<C-Right>";
            mode = ["n"];
            silent = true;
            action = ":vertical resize +2<CR>";
            desc = "Resize split right";
          }
          {
            key = "<C-Up>";
            mode = ["n"];
            silent = true;
            action = ":resize -2<CR>";
            desc = "Resize split up";
          }
          {
            key = "<C-Down>";
            mode = ["n"];
            silent = true;
            action = ":resize +2<CR>";
            desc = "Resize split down";
          }
          {
            key = "<A-Left>";
            mode = ["n"];
            silent = true;
            action = "<C-w>h";
            desc = "Move to left split";
          }
          {
            key = "<A-Right>";
            mode = ["n"];
            silent = true;
            action = "<C-w>l";
            desc = "Move to right split";
          }
          {
            key = "<A-Up>";
            mode = ["n"];
            silent = true;
            action = "<C-w>k";
            desc = "Move to upper split";
          }
          {
            key = "<A-Down>";
            mode = ["n"];
            silent = true;
            action = "<C-w>j";
            desc = "Move to lower split";
          }
        ];

        vim.languages = {
          markdown = {
            enable = true;
            treesitter.enable = true;
          };
          yaml = {
            enable = true;
            treesitter.enable = true;
          };
          nix = {
            enable = true;
            lsp.enable = true;
            extraDiagnostics.enable = true;
            format = {
              enable = true;
              type = "alejandra";
            };
            treesitter.enable = true;
          };
        };

        vim.treesitter.indent.enable = false;

        vim.luaConfigRC.treesitter-parser-fix = ''
          for _, dir in ipairs(vim.api.nvim_list_runtime_paths()) do
            for _, so in ipairs(vim.fn.glob(dir .. "/parser/vimplugin_treesitter_grammar_*.so", false, true)) do
              local lang = vim.fn.fnamemodify(so, ":t:r"):gsub("^vimplugin_treesitter_grammar_", "")
              pcall(vim.treesitter.language.add, lang, { path = so .. "/" .. lang .. ".so" })
            end
          end
        '';

        vim.luaConfigRC.treesitter-indent-fix = ''
          vim.schedule(function()
            vim.api.nvim_create_autocmd("FileType", {
              group = vim.api.nvim_create_augroup("nvf_treesitter_indent_fix", { clear = true }),
              pattern = "*",
              callback = function()
                if vim.treesitter.get_parser(0, nil, { error = false }) then
                  vim.bo.indentexpr = "v:lua.require'nvim-treesitter.indent'.get_indent(v:lnum)"
                end
              end,
            })
          end)
        '';

        vim.telescope.enable = true;
        vim.autocomplete.nvim-cmp.enable = true;
        vim.filetree.neo-tree.enable = true;
        vim.git.gitsigns.enable = true;
        vim.binds.whichKey.enable = true;

        vim.assistant.codecompanion-nvim = {
          enable = true;
          setupOpts = {
            enableDefaultKeymaps = true;
            adapters = lib.generators.mkLuaInline ''
              {
                http = {
                  llamacpp = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                      env = {
                        url = "http://127.0.0.1:8080",
                        api_key = "dummy",
                        chat_url = "/v1/chat/completions",
                      },
                      schema = {
                        model = {
                          default = "local",
                        },
                      },
                    })
                  end,

                  chatgpt_codex = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                      env = {
                        url = "https://api.openai.com/v1",
                        api_key = os.getenv("OPENAI_API_KEY"),
                        chat_url = "/chat/completions",
                      },
                      schema = {
                        model = {
                          default = "gpt-4.1-mini",
                        },
                      },
                    })
                  end,
                },
              }
            '';
            strategies = lib.generators.mkLuaInline ''
              { chat = { adapter = "llamacpp" }, inline = { adapter = "llamacpp" } }
            '';
          };
        };
      };
    };
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
    #contextSize = 8192;
    extraArgs = ["--flash-attn on"];
    #gpuLayers = 30;
  };

  services.gaming = {
    enable = true;
    extraUsers = ["henrik"];
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
