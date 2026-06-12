{...}: {
  flake.modules.nixos.vim = {
    config,
    lib,
    pkgs,
    pkgs-unstable ? pkgs,
    ...
  }: let
    cfg = config.programs.nvim;
    keymaps = import ./_vim_keymaps.nix;
  in {
    options.programs.nvim = {
      enable = lib.mkEnableOption "Henrik's Neovim configuration";
    };
    config = lib.mkIf cfg.enable {
      programs.nixvim = {
        enable = true;
        # NOTE: unstable neovim under stable nixvim (nixos-26.05) is a compat
        # risk. Consider dropping this line (use nixvim's default neovim) or
        # switching the nixvim flake input to master.
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
          ignorecase = true;
          smartcase = true;

          # New: quality of life
          undofile = true; # persistent undo across sessions
          clipboard = "unnamedplus"; # yank/paste <-> wayland clipboard (wl-clipboard)
          termguicolors = true;
          splitright = true;
          splitbelow = true;
          signcolumn = "yes"; # stop the gutter jumping when diagnostics appear
          updatetime = 300; # faster CursorHold / gitsigns blame
        };

        extraPackages = with pkgs-unstable; [
          nixd
          alejandra
          statix
          deadnix
          fd
          ripgrep
          vectorcode
          claude-code-acp
        ];

        keymaps = keymaps;

        plugins.lualine = {
          enable = true;
          settings.sections.lualine_x = [
            {
              __raw = ''
                {
                  "codecompanion",
                  icon = "",
                }
              '';
            }
            "encoding"
            "fileformat"
            "filetype"
          ];
        };

        plugins = {
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
              markdown_inline
              yaml
              nix
              c_sharp
              # For kernel / embedded work
              c
              cpp
              devicetree
              bash
              make
              # Editor self-documentation
              lua
              vim
              vimdoc
            ];
          };

          lsp = {
            enable = true;
            servers = {
              nixd.enable = true;
              # Kernel/embedded C. In a kernel tree, generate
              # compile_commands.json first:
              #   ./scripts/clang-tools/gen_compile_commands.py
              clangd.enable = true;
            };
            # The missing piece: actual LSP keybindings.
            keymaps = {
              lspBuf = {
                gd = {
                  action = "definition";
                  desc = "Go to definition";
                };
                gD = {
                  action = "declaration";
                  desc = "Go to declaration";
                };
                gi = {
                  action = "implementation";
                  desc = "Go to implementation";
                };
                gr = {
                  action = "references";
                  desc = "Find references";
                };
                K = {
                  action = "hover";
                  desc = "Hover docs";
                };
                "<leader>rn" = {
                  action = "rename";
                  desc = "Rename symbol";
                };
                "<leader>la" = {
                  action = "code_action";
                  desc = "Code action";
                };
              };
              diagnostic = {
                "[d" = {
                  action = "goto_prev";
                  desc = "Previous diagnostic";
                };
                "]d" = {
                  action = "goto_next";
                  desc = "Next diagnostic";
                };
                "<leader>ld" = {
                  action = "open_float";
                  desc = "Line diagnostics";
                };
              };
            };
          };

          roslyn-nvim.enable = true;

          conform-nvim = {
            enable = true;
            settings = {
              formatters_by_ft.nix = ["alejandra"];
              # Format on save; falls back to the LSP formatter (clangd,
              # roslyn, ...) for filetypes without an explicit entry.
              format_on_save = {
                timeout_ms = 1000;
                lsp_format = "fallback";
              };
            };
          };

          lint = {
            enable = true;
            lintersByFt.nix = ["statix" "deadnix"];
          };

          cmp = {
            enable = true;
            settings = {
              # autocomplete-on-TextChanged is nvim-cmp's default; the old
              # __raw override was redundant (and relied on a stray ';').
              completion.completeopt = "menu,menuone,noselect";
              sources = [
                {name = "nvim_lsp";}
                {name = "buffer";}
                {name = "path";}
              ];
              mapping = {
                "<C-Space>" = "cmp.mapping.complete()";
                "<C-e>" = "cmp.mapping.abort()";
                "<C-d>" = "cmp.mapping.scroll_docs(4)";
                "<C-u>" = "cmp.mapping.scroll_docs(-4)";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
                "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              };
            };
          };

          cmp-nvim-lsp.enable = true;
          cmp-buffer.enable = true;
          cmp-path.enable = true;

          nvim-colorizer = {
            enable = true;
            settings = {
              filetypes = ["*"];
              user_default_options = {
                AARRGGBB = true;
                RGB = true;
                RRGGBB = true;
                RRGGBBAA = true;
              };
            };
          };
        };

        extraPlugins = [
          pkgs.vimPlugins.ccc-nvim
          pkgs-unstable.vimPlugins.codecompanion-nvim
          # NOTE: pin these to commit SHAs instead of "main".
          # `rev = "main"` + a fixed sha256 breaks on any fresh fetch once the
          # branch moves. Get rev+hash with: nix-prefetch-github <owner> <repo>
          (pkgs.vimUtils.buildVimPlugin {
            name = "hml-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "mawkler";
              repo = "hml.nvim";
              rev = "main"; # TODO: pin commit
              sha256 = "sha256-IdsYy0K4Q1qTpUwhf97bS2vGDHB+MBjZILy1MyVlIiE=";
            };
          })
          (pkgs.vimUtils.buildVimPlugin {
            name = "neocodeium";
            src = pkgs.fetchFromGitHub {
              owner = "monkoose";
              repo = "neocodeium";
              rev = "main"; # TODO: pin commit
              sha256 = "sha256-4IejQ1dQVfmngyF7hUrQ3XXZsHWbuBm3tFDn4hUM/sA=";
            };
            doCheck = false;
          })
          (pkgs.vimUtils.buildVimPlugin {
            name = "vectorcode-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "Davidyz";
              repo = "VectorCode";
              rev = "main"; # TODO: pin commit
              sha256 = "sha256-/nxadVYrtW3vBxGFAHkbKUj0F6PTED4PoRtx9Cjf4No=";
            };
            doCheck = false;
          })
          (pkgs.vimUtils.buildVimPlugin {
            name = "codecompanion-spinners-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "lalitmee";
              repo = "codecompanion-spinners.nvim";
              rev = "main"; # TODO: pin commit
              sha256 = "sha256-L+vG4wj2O1VaiHhhjBAi26nglW0WnPSTk8FihkK8cn0=";
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

          require("vectorcode").setup({})

          require("codecompanion").setup({
            display = {
              chat = {
                window = {
                  layout = "float",
                  width = 0.8,
                  height = 0.8,
                  relative = "editor",
                  border = "rounded",
                  pertab = true,
                },
              },
            },
            adapters = {
              acp = {
                claude_code = function()
                  return require("codecompanion.adapters").extend("claude_code", {})
                end,
              },
              http = {
                llamacpp = function()
                  return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                      url      = "http://127.0.0.1:8080",
                      api_key  = "dummy",
                      chat_url = "/v1/chat/completions",
                    },
                    schema = {
                      model = { default = "Qwen3.6-27B-UD-Q4_K_XL-MTP" },
                    },
                    opts = { tools = true },
                  })
                end,
              },
            },
            strategies = {
              chat   = { adapter = "llamacpp" },
              inline = { adapter = "llamacpp" },
            },
            extensions = {
              spinner = {
                opts = {
                  style = "dots",
                },
              },
              vectorcode = {
                opts = {
                  tool_group = {
                    enabled = true,
                    extras = {},
                    collapse = false,
                  },
                  tool_opts = {
                    ["*"] = {},
                    query = {
                      default_num = { chunk = 50, document = 10 },
                      max_num     = { chunk = -1, document = -1 },
                    },
                  },
                },
              },
            },
          })
        '';
      };
    };
  };
}
