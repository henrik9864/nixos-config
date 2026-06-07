{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.username = "henrik";
  home.homeDirectory = "/home/henrik";

  home.activation.cleanupStaleSymlinks = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
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
    ./scripts.nix
  ];

  home.file.".config/aichat/.aichatignore".text = ''
    .git/
    *.lock
  '';

  home.packages = with pkgs; [
    # Nix tooling
    home-manager
    nix-search-tv
    nixd
    nixfmt
    statix
    deadnix

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    # System utilities
    efibootmgr
    pciutils
    evtest
    nmap
    curl
    jq
    htop
    ncdu
    tree
    fd

    # Desktop utilities
    swaynotificationcenter
    wlogout
    waypaper
		awww
    udiskie
    nemo
    rofi

    # Clipboard
    cliphist
    wl-clipboard

    # Audio
    pavucontrol
    playerctl

    # Screenshots
    grim
    slurp

    # Chat
    discord

    # Gaming
    prismlauncher
    ckan

    # Monitoring
    siomon

    # Coding
		claude-code
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

  programs.git = {
    enable = true;
    settings.user = {
      name = "Henrik Strocka";
      email = "henstr@hotmail.com";
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      export LS_COLORS="$LS_COLORS:ow=1;38;2;0;0;0;48;2;64;160;43"
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
        exec start-hyprland
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
    v = "nvim";
    b = "yazi";
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
      size = 9.5;
    };
    keybindings = {
      "ctrl+insert" = "copy_to_clipboard";
      "shift+insert" = "paste_from_clipboard";
    };
    settings = {
      background_opacity = "0.85";
      cursor_trail = 1;
      cursor_trail_devay = "0.1 0.4";
    };
    extraConfig = ''
      startup_session ~/.config/kitty/startup.session
    '';
  };

  programs.yazi = {
    enable = true;
		shellWrapperName = "yy";

    settings = {
      opener = {
        edit = [
          {
            run = ''vim "$@"'';
            block = true;
          }
        ];
      };
    };
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
