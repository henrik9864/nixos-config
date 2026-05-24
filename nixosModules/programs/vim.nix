{
  config,
  lib,
  pkgs,
  pkgs-unstable ? pkgs,
  ...
}:
let
  cfg = config.programs.nvim;
in
{
  options.programs.nvim = {
    enable = lib.mkEnableOption "Henrik's Neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;
      globals.mapleader = " ";

      colorschemes.gruvbox = {
        enable = true;
        settings.transparent_mode = true;
      };

      opts = {
        number = true;
        relativenumber = true;
        smartindent = true;
        shiftwidth = 2;
        tabstop = 2;
        whichwrap = "b,s,<,>,[,],h,l";
        scrolloff = 5;
        smoothscroll = true;
      };

      extraPackages = with pkgs-unstable; [
        nixd
        alejandra
        statix
        fd
      ];

      keymaps = [
        { key = "<leader>e";  mode = [ "n" ];      action = ":Neotree toggle<CR>";           options = { silent = true; desc = "Toggle file tree"; }; }
        { key = "<leader>f";  mode = [ "n" ];      action = ":w<bar>!alejandra %<CR>";       options = { silent = true; desc = "Format Nix file with alejandra"; }; }
        { key = "<leader>r";  mode = [ "n" ];      action = ":Telescope find_files<CR>";     options = { silent = true; desc = "Find files"; }; }
        { key = "<leader>cc"; mode = [ "n" ];      action = ":CodeCompanionChat toggle<CR>"; options = { silent = true; desc = "Toggle CodeCompanion chat"; }; }

        { key = "<C-Left>";   mode = [ "n" ]; action = ":vertical resize -2<CR>"; options = { silent = true; desc = "Resize split left"; }; }
        { key = "<C-Right>";  mode = [ "n" ]; action = ":vertical resize +2<CR>"; options = { silent = true; desc = "Resize split right"; }; }
        { key = "<C-Up>";     mode = [ "n" ]; action = ":resize -2<CR>";          options = { silent = true; desc = "Resize split up"; }; }
        { key = "<C-Down>";   mode = [ "n" ]; action = ":resize +2<CR>";          options = { silent = true; desc = "Resize split down"; }; }

        { key = "<A-Left>";   mode = [ "n" ]; action = "<C-w>h"; options = { silent = true; desc = "Move to left split"; }; }
        { key = "<A-Right>";  mode = [ "n" ]; action = "<C-w>l"; options = { silent = true; desc = "Move to right split"; }; }
        { key = "<A-Up>";     mode = [ "n" ]; action = "<C-w>k"; options = { silent = true; desc = "Move to upper split"; }; }
        { key = "<A-Down>";   mode = [ "n" ]; action = "<C-w>j"; options = { silent = true; desc = "Move to lower split"; }; }

        { key = "<leader>cp"; mode = [ "n" ];      action = ":CccPick<CR>"; options = { silent = true; desc = "Open color picker"; }; }

        { key = "å"; mode = [ "n" "v" ]; action = "{"; options = { silent = true; desc = "Paragraph up (Norwegian keyboard)"; }; }
        { key = "¨"; mode = [ "n" "v" ]; action = "}"; options = { silent = true; desc = "Paragraph down (Norwegian keyboard)"; }; }
        { key = "ø"; mode = [ "n" "v" ]; action = ":"; options = { silent = true; desc = "Command mode (Norwegian keyboard)"; }; }

        { key = "<A-f>"; mode = [ "i" ]; action = "<cmd>lua require('neocodeium').accept()<CR>";            options = { silent = true; desc = "Accept neocodeium suggestion"; }; }
        { key = "<A-w>"; mode = [ "i" ]; action = "<cmd>lua require('neocodeium').accept_word()<CR>";       options = { silent = true; desc = "Accept neocodeium word"; }; }
        { key = "<A-e>"; mode = [ "i" ]; action = "<cmd>lua require('neocodeium').cycle_or_complete()<CR>"; options = { silent = true; desc = "Cycle neocodeium suggestions"; }; }
      ];

      plugins = {
        lualine.enable = true;
        telescope.enable = true;
        neo-tree.enable = true;
        gitsigns.enable = true;
        which-key.enable = true;
        indent-blankline.enable = true;
        web-devicons.enable = true;

        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = false;
          grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
            markdown
            yaml
            nix
            c_sharp
          ];
        };

        lsp = {
          enable = true;
          servers.nixd.enable = true;
        };

        roslyn-nvim = {
          enable = true;
        };

        conform-nvim = {
          enable = true;
          settings.formatters_by_ft.nix = [ "alejandra" ];
        };

        lint = {
          enable = true;
          lintersByFt.nix = [ "statix" ];
        };

        cmp = {
          enable = true;
          settings = {
            completion = {
              autocomplete = [ { __raw = "require('cmp').TriggerEvent.TextChanged"; } ];
              completeopt = "menu,menuone,noselect";
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "buffer"; }
              { name = "path"; }
            ];
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>"      = "cmp.mapping.confirm({ select = true })";
              "<Tab>"     = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<S-Tab>"   = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            };
          };
        };

        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true;

        nvim-colorizer = {
          enable = true;
          settings = {
            filetypes = [ "*" ];
            user_default_options = {
              AARRGGBB = true;
              RGB = true;
              RRGGBB = true;
              RRGGBBAA = true;
            };
          };
        };

        codecompanion = {
          enable = true;
          settings = {
            display.chat.window = {
              layout = "float";
              width = 0.8;
              height = 0.8;
              relative = "editor";
              border = "rounded";
            };
            adapters.http.llamacpp = {
              __raw = ''
                function()
                  return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                      url      = "http://127.0.0.1:8080",
                      api_key  = "dummy",
                      chat_url = "/v1/chat/completions",
                    },
                    schema = {
                      model = { default = "Qwen3.6-27B-UD-Q5_K_XL-MTP" },
                    },
                  })
                end
              '';
            };
            strategies = {
              chat.adapter   = "llamacpp";
              inline.adapter = "llamacpp";
            };
          };
        };
      };

      extraPlugins = [
        pkgs.vimPlugins.ccc-nvim
        (pkgs.vimUtils.buildVimPlugin {
          name = "hml-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "mawkler";
            repo = "hml.nvim";
            rev = "main";
            sha256 = "sha256-IdsYy0K4Q1qTpUwhf97bS2vGDHB+MBjZILy1MyVlIiE=";
          };
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "neocodeium";
          src = pkgs.fetchFromGitHub {
            owner = "monkoose";
            repo = "neocodeium";
            rev = "main";
            sha256 = "sha256-4IejQ1dQVfmngyF7hUrQ3XXZsHWbuBm3tFDn4hUM/sA=";
          };
					doCheck = false;
        })
      ];

      extraConfigLua = ''
        require("ccc").setup({})
        require("hml").setup({})

        require("neocodeium").setup({
          manual = true,
        })

        vim.api.nvim_create_autocmd("User", {
          pattern = "NeoCodeiumCompletionDisplayed",
          callback = function() require("cmp").abort() end,
        })
      '';
    };
  };
}
