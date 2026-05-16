{
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim.package = pkgs-unstable.neovim-unwrapped;

      vim.theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
        transparent = true;
      };

      vim.statusline.lualine.enable = true;

      vim.options = {
        smartindent = true;
        shiftwidth = 2;
        tabstop = 2;
        whichwrap = "b,s,<,>,[,],h,l";
        scrolloff = 5;
        smoothscroll = true;
      };

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
        csharp = {
          enable = true;
          lsp = {
            enable = true;
            server = "roslyn";
          };
          treesitter.enable = true;

        };
      };

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
      vim.filetree.neo-tree.enable = true;
      vim.git.gitsigns.enable = true;
      vim.binds.whichKey.enable = true;
      vim.visuals.indent-blankline.enable = true;
      vim.treesitter.indent.enable = false;
      vim.lsp.enable = true;

      vim.autocomplete.nvim-cmp = {
        enable = true;

        setupOpts = {
          completion = {
            autocomplete = ["TextChanged"];
            completeopt = "menu,menuone,noselect";
          };
        };
      };

      vim.ui.colorizer = {
        enable = true;

        setupOpts.filetypes."*" = {
          AARRGGBB = true;
          RGB = true;
          RRGGBB = true;
          RRGGBBAA = true;
        };
      };

      vim.extraPlugins = {
        ccc-nvim = {
          package = pkgs.vimPlugins.ccc-nvim;
          setup = ''require("ccc").setup({})'';
        };

        hml-nvim = {
          package = pkgs.vimUtils.buildVimPlugin {
            name = "hml-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "mawkler";
              repo = "hml.nvim";
              rev = "main";
              sha256 = "sha256-IdsYy0K4Q1qTpUwhf97bS2vGDHB+MBjZILy1MyVlIiE=";
            };
          };
          setup = ''require("hml").setup({})'';
        };
      };

      vim.assistant.codecompanion-nvim = {
        enable = true;
        setupOpts = {
          enableDefaultKeymaps = true;

          display = {
            chat = {
              window = {
                layout = "float";
                width = 0.8;
                height = 0.8;
                relative = "editor";
                border = "rounded";
              };
            };
          };

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
                        default = "Qwen3.6-27B-Q3_K_M",
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
}
