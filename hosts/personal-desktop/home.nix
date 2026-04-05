{ pkgs, inputs, ... }:

{
  imports = [
    #inputs.plasma-manager.homeModules.plasma-manager
  ];

  home.username = "henrik";
  home.homeDirectory = "/home/henrik";

  home.packages = with pkgs; [
    # Nix linting/formatting
    nixd
    nixfmt-rfc-style

    # Fonts
    nerd-fonts.jetbrains-mono

    efibootmgr
    lon
    discord
    pciutils
  ];

  home.sessionVariables = { };

  home.file = { };

  # programs.plasma = {
  #   enable = true;
  #   workspace = {
  #     lookAndFeel = "org.kde.breezedark.desktop";
  #     colorScheme = "CatppuccinMochaBlue";
  #     iconTheme = "Papirus-Dark";
  #   };
  #
  #   hotkeys.commands."launch-kitty" = {
  #     name = "Launch Kitty";
  #     key = "Ctrl+Alt+T";
  #     command = "kitty";
  #   };
  #
  #   configFile."kdeglobals"."General"."TerminalApplication" = "kitty";
  #   configFile."kdeglobals"."General"."TerminalService" = "kitty.desktop";
  # };

  #wayland.windowManager.hyprland = {
  #  enable = true;

  #  xwayland.enable = true;
  #  settings = {
  #    input = {
  #      kb_layout = "us";
  #    };
  #  };
  #};

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixfmt";
      "nix.nixpkgs.expr" = "import <nixpkgs> { }";
      "[nix]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Henrik Strocka";
    userEmail = "henstr@hotmail.com";
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      export LS_COLORS="$LS_COLORS:ow=1;38;2;0;0;0;48;2;64;160;43"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
        "z"
      ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Mocha";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
