{
  config,
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
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    inputs.hyprsession.packages.${pkgs.system}.default
    alejandra
    gcc
    file
    ripgrep
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.henrik = import ./_home/home.nix;
    backupFileExtension = "backup";
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.nvf = {
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
          key = "<leader>cc";
          mode = ["n"];
          silent = true;
          action = ":CodeCompanionChat toggle<CR>";
          desc = "Toggle CodeCompanion chat";
        }
        {
          key = "<leader>f";
          mode = ["n"];
          silent = true;
          action = ":w<bar>!alejandra %<CR>";
          desc = "Format Nix file with alejandra";
        }
        {
          key = "<C-Left>";
          mode = ["n"];
          action = ":vertical resize -2<CR>";
          desc = "Resize split left";
          silent = true;
        }
        {
          key = "<C-Right>";
          mode = ["n"];
          action = ":vertical resize +2<CR>";
          desc = "Resize split right";
          silent = true;
        }
        {
          key = "<C-Up>";
          mode = ["n"];
          action = ":resize -2<CR>";
          desc = "Resize split up";
          silent = true;
        }
        {
          key = "<C-Down>";
          mode = ["n"];
          action = ":resize +2<CR>";
          desc = "Resize split down";
          silent = true;
        }

        # Move between splits with Shift+Arrow
        {
          key = "<A-Left>";
          mode = ["n"];
          action = "<C-w>h";
          desc = "Move to left split";
          silent = true;
        }
        {
          key = "<A-Right>";
          mode = ["n"];
          action = "<C-w>l";
          desc = "Move to right split";
          silent = true;
        }
        {
          key = "<A-Up>";
          mode = ["n"];
          action = "<C-w>k";
          desc = "Move to upper split";
          silent = true;
        }
        {
          key = "<A-Down>";
          mode = ["n"];
          action = "<C-w>j";
          desc = "Move to lower split";
          silent = true;
        }
        {
          key = "<leader>f";
          mode = ["n"];
          silent = true;
          action = ":Telescope find_files<CR>";
          desc = "Find files";
        }
        {
          key = "<leader>v";
          mode = ["x"];
          silent = true;
          action = ":<C-u>lua ask_codecompanion()<CR>";
          desc = "Ask CodeCompanion about selection";
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

      vim.luaConfigRC.treesitter-parser-fix = ''
        -- Register Nix-packaged treesitter grammars that have mangled names
        for _, dir in ipairs(vim.api.nvim_list_runtime_paths()) do
          for _, so in ipairs(vim.fn.glob(dir .. "/parser/vimplugin_treesitter_grammar_*.so", false, true)) do
            local lang = vim.fn.fnamemodify(so, ":t:r"):gsub("^vimplugin_treesitter_grammar_", "")
            pcall(vim.treesitter.language.add, lang, { path = so .. "/" .. lang .. ".so" })
          end
        end
      '';

      vim.treesitter.indent.enable = false;

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

      vim.assistant = {
        codecompanion-nvim = {
          enable = true;
          setupOpts = {
            enableDefaultKeymaps = true;
            adapters = lib.generators.mkLuaInline ''
              {
                ollama = require("codecompanion.adapters").extend("ollama", {
                  schema = { model = { default = "gemma4:e4b" } },
                }),
                copilot = require("codecompanion.adapters").extend("copilot", {
                  schema = { model = { default = "gpt-5.4-mini" } },
                }),
                ["copilot-opus"] = require("codecompanion.adapters").extend("copilot", {
                  schema = { model = { default = "claude-opus-4" } },
                }),
                ["copilot-sonnet"] = require("codecompanion.adapters").extend("copilot", {
                  schema = { model = { default = "claude-sonnet-4" } },
                }),
              }
            '';
            strategies = lib.generators.mkLuaInline ''
              { chat = { adapter = "copilot" }, inline = { adapter = "copilot" } }
            '';
          };
        };
      };

      #TODO remove this line

      vim.luaConfigRC.quick-ask = ''
        _G.ask_codecompanion = function()
          local start_pos = vim.api.nvim_buf_get_mark(0, "<")
          local end_pos = vim.api.nvim_buf_get_mark(0, ">")
          local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
          if #lines > 0 then
            lines[#lines] = lines[#lines]:sub(1, end_pos[2] + 1)
            lines[1] = lines[1]:sub(start_pos[2] + 1)
          end
          local selected_text = table.concat(lines, "\n")
          vim.ui.input({ prompt = "Ask about selection: " }, function(input)
            if not input or input == "" then return end
            local prompt = string.format("```\n%s\n```\n\n%s", selected_text, input)
            require("codecompanion").chat({ content = prompt })
          end)
        end
      '';
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
    extraUsers = ["henrik"];
  };

  services.gaming = {
    enable = true;
    extraUsers = ["henrik"];
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
