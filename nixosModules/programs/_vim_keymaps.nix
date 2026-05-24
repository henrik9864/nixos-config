[
  {
    key = "<leader>e";
    mode = ["n"];
    action = ":Neotree toggle<CR>";
    options = {
      silent = true;
      desc = "Toggle file tree";
    };
  }
  {
    key = "<leader>f";
    mode = ["n"];
    action = ":w<bar>!alejandra %<CR>";
    options = {
      silent = true;
      desc = "Format Nix file with alejandra";
    };
  }
  {
    key = "<leader>r";
    mode = ["n"];
    action = ":Telescope find_files<CR>";
    options = {
      silent = true;
      desc = "Find files";
    };
  }
  {
    key = "<leader>cc";
    mode = ["n"];
    action = ":CodeCompanionChat toggle<CR>";
    options = {
      silent = true;
      desc = "Toggle CodeCompanion chat";
    };
  }

  {
    key = "<C-Left>";
    mode = ["n"];
    action = ":vertical resize -2<CR>";
    options = {
      silent = true;
      desc = "Resize split left";
    };
  }
  {
    key = "<C-Right>";
    mode = ["n"];
    action = ":vertical resize +2<CR>";
    options = {
      silent = true;
      desc = "Resize split right";
    };
  }
  {
    key = "<C-Up>";
    mode = ["n"];
    action = ":resize -2<CR>";
    options = {
      silent = true;
      desc = "Resize split up";
    };
  }
  {
    key = "<C-Down>";
    mode = ["n"];
    action = ":resize +2<CR>";
    options = {
      silent = true;
      desc = "Resize split down";
    };
  }

  {
    key = "<A-Left>";
    mode = ["n"];
    action = "<C-w>h";
    options = {
      silent = true;
      desc = "Move to left split";
    };
  }
  {
    key = "<A-Right>";
    mode = ["n"];
    action = "<C-w>l";
    options = {
      silent = true;
      desc = "Move to right split";
    };
  }
  {
    key = "<A-Up>";
    mode = ["n"];
    action = "<C-w>k";
    options = {
      silent = true;
      desc = "Move to upper split";
    };
  }
  {
    key = "<A-Down>";
    mode = ["n"];
    action = "<C-w>j";
    options = {
      silent = true;
      desc = "Move to lower split";
    };
  }

  {
    key = "<leader>cp";
    mode = ["n"];
    action = ":CccPick<CR>";
    options = {
      silent = true;
      desc = "Open color picker";
    };
  }

  {
    key = "å";
    mode = ["n" "v"];
    action = "{";
    options = {
      silent = true;
      desc = "Paragraph up (Norwegian keyboard)";
    };
  }
  {
    key = "¨";
    mode = ["n" "v"];
    action = "}";
    options = {
      silent = true;
      desc = "Paragraph down (Norwegian keyboard)";
    };
  }
  {
    key = "ø";
    mode = ["n" "v"];
    action = ":";
    options = {
      silent = true;
      desc = "Command mode (Norwegian keyboard)";
    };
  }
]

