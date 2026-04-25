{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = ["ahci" "sd_mod"];
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
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    fastfetch
    alejandra
    gcc
    file
    ripgrep
    inputs.hyprsession.packages.${pkgs.system}.default
  ];

  # Programs
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    nix-index-database.comma.enable = true;

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
            key = "<leader>v";
            mode = ["x"];
            silent = true;
            action = ":<C-u>lua ask_codecompanion()<CR>";
            desc = "Ask CodeCompanion about selection";
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
      options = ["rw" "nolock"];
    };
  };

  services.llm = {
    enable = true;
    acceleration = "cuda";
    models = ["llama3.2" "gemma4:26b" "gemma4:e4b"];
    extraUsers = ["henrik"];
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
