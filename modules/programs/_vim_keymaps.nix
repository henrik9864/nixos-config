[
  # General
  {
    key = "<leader>e";
    mode = ["n"];
    action = ":Neotree toggle<CR>";
    options = { silent = true; desc = "Toggle file tree"; };
  }
  {
    key = "<leader>f";
    mode = ["n"];
    action = ":w<bar>!alejandra %<CR>";
    options = { silent = true; desc = "Format Nix file with alejandra"; };
  }
  {
    key = "<leader>r";
    mode = ["n"];
    action = ":Telescope find_files<CR>";
    options = { silent = true; desc = "Find files"; };
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

  # Norwegian keyboard
  {
    key = "å";
    mode = ["n" "v" "i"];
    action = "{";
    options = { silent = true; desc = "{ (Norwegian keyboard)"; };
  }
  {
    key = "¨";
    mode = ["n" "v" "i"];
    action = "}";
    options = { silent = true; desc = "} (Norwegian keyboard)"; };
  }
  {
    key = "ø";
    mode = ["n" "v"];
    action = ":";
    options = { silent = true; desc = "Command mode (Norwegian keyboard)"; };
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
