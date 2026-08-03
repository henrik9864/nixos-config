{
  pkgs,
  pkgs-unstable,
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

  home.packages = with pkgs; [
    # Nix tooling
    home-manager
    nix-search-tv
    nixd
    nixfmt
    statix
    deadnix
    ydotool

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
    tio

    # Desktop utilities
    udiskie
    nemo

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

    # Productivity
    libreoffice

    # Coding
    pkgs-unstable.claude-code
    pkgs-unstable.opencode

    # Emulator
    melonDS

    # 3D Printing
    prusa-slicer
  ];

  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider."llama.cpp" = {
      npm = "@ai-sdk/openai-compatible";
      name = "llama-server (local)";
      options.baseURL = "http://127.0.0.1:8080/v1";
      models."qwen27b-q5-mtp" = {
        name = "Qwen3 27B Q5 MTP (local)";
        limit = {
          context = 32768;
          output = 8192;
        };
      };
    };
    model = "llama.cpp/qwen27b-q5-mtp";
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
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
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
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
    ndc = "nix develop -c $SHELL";
    v = "nvim";
    b = "yazi";

    gs = "git status -s";
    ga = "git add";
    gr = "git reset";
    gll = "git log --oneline --graph --decorate --all";
    gundo = "git reset HEAD~1 --mixed";
    gnah = "git reset --hard && git clean -fd";
    gri = "git rebase -i HEAD~";
    gwip = "git add -A && git commit -m 'WIP'";
    gcfix = "git commit --fixup";

    dr = "dotnet run";
    db = "dotnet build";
    dt = "dotnet test";
    dw = "dotnet watch";
    dR = "dotnet restore";
    dc = "dotnet clean";
    dp = "dotnet publish";
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
