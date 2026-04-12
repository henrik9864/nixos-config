{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home.username = "henrik";
  home.homeDirectory = "/home/henrik";

  home.activation.cleanupStaleSymlinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for path in \
      "$HOME/.config/hypr" \
      "$HOME/.config/waybar" \
      "$HOME/.gtkrc-2.0"; do
      if [ -L "$path" ]; then
        echo "Removing stale symlink: $path"
        rm "$path"
      fi
    done
  '';

  imports = [
    ./hyprland/default.nix
    ./waybar/default.nix
    ./scripts.nix
  ];

  home.file.".config/waypaper/config.ini".text = ''
    [Settings]
    folder = ~/walls
    backend = hyprpaper
    monitors = All
    fill = fillRRRRRRRR
    sort = name
    color = #ffffff
    subfolders = False
    show_hidden = False
    show_exif = False
  '';

  home.file.".config/aichat/.aichatignore".text = ''
    .git/
    *.lock
  '';

  home.packages = with pkgs; [
    home-manager
    nix-search-tv
    nixd
    nixfmt-rfc-style
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    efibootmgr
    discord
    pciutils
    swaynotificationcenter
    wlogout
    waypaper
    hyprpaper
    udiskie
    cliphist
    wl-clipboard
    pavucontrol
    playerctl
    grim
    slurp
    nemo
    rofi
    nmap
    curl
    jq
    htop
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-tooltip-timeout = 0;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-tooltip-timeout = 0;
    };
  };

  programs.aichat = {
    enable = true;
    settings = {
      model = "ollama:llama3.2";
      clients = [
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "http://127.0.0.1:11434/v1";
          models = [
            {
              name = "llama3.2";
              supports_function_calling = true;
            }
          ];
        }
      ];
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [ jnoortheen.nix-ide ];
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
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Henrik Strocka";
      email = "henstr@hotmail.com";
    };
  };

  #programs.neovim = {
  #  enable = true;
  #  extraConfig = ''
  #    set number relativenumber
  #  '';
  #};

  programs.zsh = {
    enable = true;
    initContent = ''
      export LS_COLORS="$LS_COLORS:ow=1;38;2;0;0;0;48;2;64;160;43"
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
        exec Hyprland
      fi
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

  programs.zsh.shellAliases = {
    nrs = "sudo nixos-rebuild switch";
    nrsf = "sudo nixos-rebuild switch --fast";
    ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    keybindings = {
      "ctrl+insert" = "copy_to_clipboard";
      "shift+insert" = "paste_from_clipboard";
    };
    settings = {
      background_opacity = "0.85";
    };
    extraConfig = ''
      startup_session ~/.config/kitty/startup.session
    '';
  };

  home.file.".config/kitty/startup.session".text = ''
    launch --type=os-window sh -c "fastfetch; exec $SHELL"
  '';

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
