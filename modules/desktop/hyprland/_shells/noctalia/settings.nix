{ ... }: {
  wayland.windowManager.hyprland.configType = "hyprlang";
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    general = {
      layout = "dwindle";
      gaps_in = 8;
      gaps_out = 16;
      border_size = 2;
      "col.active_border" = "rgb(C9A0FF) rgb(8AB4F8) 45deg";
      "col.inactive_border" = "rgba(2E2F3866)";
      resize_on_border = true;
      hover_icon_on_border = true;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      focus_on_activate = true;
      middle_click_paste = false;
      disable_autoreload = false;
      animate_manual_resizes = true;
      animate_mouse_windowdragging = true;
    };

    debug = {
      vfr = true;
      disable_logs = false;
    };

    dwindle = {
      force_split = 2;
      preserve_split = true;
      use_active_for_splits = true;
    };

    master.new_status = "master";

    decoration = {
      rounding = 14;
      active_opacity = 1.0;
      inactive_opacity = 0.96;
      blur = {
        enabled = true;
        size = 6;
        passes = 3;
        noise = 0.02;
        contrast = 1.2;
        brightness = 1.0;
        xray = true;
        vibrancy = 0.2;
        new_optimizations = true;
      };
      shadow = {
        enabled = true;
        range = 30;
        render_power = 3;
        offset = "0 4";
        color = "rgba(00000099)";
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "noctalia,    0.25, 1,    0.5, 1"
        "noctaliaOut, 0.6,  0,    0.6, 1"
        "noctaliaIn,  0.2,  0,    0.2, 1"
        "wind,        0.05, 0.9,  0.1, 1.05"
      ];
      animation = [
        "windowsIn,    1, 5,  noctalia,    popin 60%"
        "windowsOut,   1, 4,  noctaliaOut, popin 60%"
        "windowsMove,  1, 5,  wind,        slide"
        "fadeIn,       1, 3,  noctalia"
        "fadeOut,      1, 3,  noctaliaOut"
        "fadeSwitch,   1, 2,  noctalia"
        "fadeShadow,   1, 6,  noctalia"
        "fadeDim,      1, 3,  noctalia"
        "border,       1, 8,  noctalia"
        "borderangle,  1, 60, noctalia, loop"
        "workspaces,   1, 5,  noctalia, slidefadevert 20%"
        "specialWorkspace, 1, 5, noctalia, slidefadevert -20%"
      ];
    };

    xwayland.force_zero_scaling = true;

    env = [
      "XCURSOR_THEME,Bibata-Modern-Classic"
      "XCURSOR_SIZE,24"
    ];
  };
}
