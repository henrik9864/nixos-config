{
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs.nvf.settings.vim.keymaps = [
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
    {
      key = "<leader>cp";
      mode = ["n"];
      silent = true;
      action = ":CccPick<CR>";
      desc = "Open color picker";
    }
    {
      key = "å";
      mode = ["n" "v"];
      silent = true;
      action = "{";
      desc = "Paragraph up (Norwegian keyboard)";
    }
    {
      key = "¨";
      mode = ["n" "v"];
      silent = true;
      action = "}";
      desc = "Paragraph down (Norwegian keyboard)";
    }
    {
      key = "ø";
      mode = ["n" "v"];
      silent = true;
      action = ":";
      desc = "Command mode (Norwegian keyboard)";
    }
  ];
}
