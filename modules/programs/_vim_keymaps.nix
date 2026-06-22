[
  # General
  {
    key = "<leader>e";
    mode = ["n"];
    action = ":Neotree toggle<CR>";
    options = { silent = true; desc = "Toggle file tree"; };
  }
  {
    # Was ":w|!alejandra %" — that reformatted the file on disk *after* the
    # write, leaving the buffer stale. conform formats the buffer in place
    # (and format_on_save already covers the common case).
    key = "<leader>f";
    mode = ["n"];
    action.__raw = ''function() require("conform").format({ async = true, lsp_format = "fallback" }) end'';
    options = { silent = true; desc = "Format buffer"; };
  }

  # Telescope (rg and fd are already installed)
  {
    key = "<leader>r";
    mode = ["n"];
    action = ":Telescope find_files<CR>";
    options = { silent = true; desc = "Find files"; };
  }
  {
    key = "<leader>g";
    mode = ["n"];
    action = ":Telescope live_grep<CR>";
    options = { silent = true; desc = "Grep project"; };
  }
  {
    key = "<leader>b";
    mode = ["n"];
    action = ":Telescope buffers<CR>";
    options = { silent = true; desc = "Open buffers"; };
  }
  {
    key = "<leader>o";
    mode = ["n"];
    action = ":Telescope oldfiles<CR>";
    options = { silent = true; desc = "Recent files"; };
  }
  {
    key = "<leader>q";
    mode = ["n"];
    action = ":Telescope diagnostics<CR>";
    options = { silent = true; desc = "Workspace diagnostics"; };
  }
  {
    key = "<leader>s";
    mode = ["n"];
    action = ":Telescope lsp_document_symbols<CR>";
    options = { silent = true; desc = "Document symbols"; };
  }
  {
    key = "<leader>S";
    mode = ["n"];
    action = ":Telescope lsp_workspace_symbols<CR>";
    options = { silent = true; desc = "Workspace symbols"; };
  }
  {
    key = "<leader>gx";
    mode = ["n"];
    action = ":Telescope git_commits<CR>";
    options = { silent = true; desc = "Git commits"; };
  }
  {
    key = "<leader>gb";
    mode = ["n"];
    action = ":Telescope git_branches<CR>";
    options = { silent = true; desc = "Git branches"; };
  }
  {
    key = "<leader>/";
    mode = ["n"];
    action = ":Telescope current_buffer_fuzzy_find<CR>";
    options = { silent = true; desc = "Fuzzy find in buffer"; };
  }
  {
    key = "<leader>k";
    mode = ["n"];
    action = ":Telescope keymaps<CR>";
    options = { silent = true; desc = "Search keymaps"; };
  }
  {
    key = "<leader>G";
    mode = ["n"];
    action = ":Telescope grep_string<CR>";
    options = { silent = true; desc = "Grep word under cursor"; };
  }

  # CodeCompanion
  {
    key = "<leader>cc";
    mode = ["n"];
    action = ":CodeCompanionChat toggle<CR>";
    options = { silent = true; desc = "Toggle CodeCompanion chat"; };
  }
  {
    key = "<leader>ca";
    mode = ["n"];
    action.__raw = ''function() require("codecompanion").chat({ type = "acp", adapter = "claude_code" }) end'';
    options = { silent = true; desc = "Claude Code ACP chat"; };
  }

  # Split resize
  {
    key = "<C-Left>";
    mode = ["n"];
    action = ":vertical resize -2<CR>";
    options = { silent = true; desc = "Resize split left"; };
  }
  {
    key = "<C-Right>";
    mode = ["n"];
    action = ":vertical resize +2<CR>";
    options = { silent = true; desc = "Resize split right"; };
  }
  {
    key = "<C-Up>";
    mode = ["n"];
    action = ":resize -2<CR>";
    options = { silent = true; desc = "Resize split up"; };
  }
  {
    key = "<C-Down>";
    mode = ["n"];
    action = ":resize +2<CR>";
    options = { silent = true; desc = "Resize split down"; };
  }

  # Split navigation
  {
    key = "<A-Left>";
    mode = ["n"];
    action = "<C-w>h";
    options = { silent = true; desc = "Move to left split"; };
  }
  {
    key = "<A-Right>";
    mode = ["n"];
    action = "<C-w>l";
    options = { silent = true; desc = "Move to right split"; };
  }
  {
    key = "<A-Up>";
    mode = ["n"];
    action = "<C-w>k";
    options = { silent = true; desc = "Move to upper split"; };
  }
  {
    key = "<A-Down>";
    mode = ["n"];
    action = "<C-w>j";
    options = { silent = true; desc = "Move to lower split"; };
  }

  # Color picker
  {
    key = "<leader>cp";
    mode = ["n"];
    action = ":CccPick<CR>";
    options = { silent = true; desc = "Open color picker"; };
  }

  # Norwegian keyboard — maps physical key positions to their US equivalents.
  # å/¨/ø/æ sit at [/]/;/' on a US layout; insert mode excluded so literal
  # characters can still be typed. AltGr+7/0 still produce {/} in insert mode.
  # Note: } (paragraph forward) has no clean key — use AltGr+0 when needed.
  {
    key = "å";
    mode = ["n" "v" "o"];
    action = "[";
    options = { silent = true; desc = "[ (Norwegian keyboard)"; };
  }
  {
    key = "Å";
    mode = ["n" "v" "o"];
    action = "{";
    options = { silent = true; desc = "{ (Norwegian keyboard)"; };
  }
  {
    key = "¨";
    mode = ["n" "v" "o"];
    action = "]";
    options = { silent = true; desc = "] (Norwegian keyboard)"; };
  }
  {
    key = "ø";
    mode = ["n" "v"];
    action = ";";
    options = { silent = true; desc = "; repeat f/t (Norwegian keyboard)"; };
  }
  {
    key = "Ø";
    mode = ["n" "v"];
    action = ":";
    options = { silent = true; desc = ": command mode (Norwegian keyboard)"; };
  }
  {
    key = "æ";
    mode = ["n" "v" "o"];
    action = "'";
    options = { silent = true; desc = "' jump to mark (Norwegian keyboard)"; };
  }
  {
    key = "Æ";
    mode = ["n" "v"];
    action = "@";
    options = { silent = true; desc = "@ run macro (Norwegian keyboard)"; };
  }
  {
    key = "ææ";
    mode = ["n"];
    action = "@@";
    options = { silent = true; desc = "@@ repeat last macro (Norwegian keyboard)"; };
  }

  # Neocodeium
  {
    key = "<A-f>";
    mode = ["i"];
    action = "<cmd>lua require('neocodeium').accept()<CR>";
    options = { silent = true; desc = "Accept neocodeium suggestion"; };
  }
  {
    key = "<A-w>";
    mode = ["i"];
    action = "<cmd>lua require('neocodeium').accept_word()<CR>";
    options = { silent = true; desc = "Accept neocodeium word"; };
  }
  {
    key = "<A-e>";
    mode = ["i"];
    action = "<cmd>lua require('neocodeium').cycle_or_complete()<CR>";
    options = { silent = true; desc = "Cycle neocodeium suggestions"; };
  }
]
