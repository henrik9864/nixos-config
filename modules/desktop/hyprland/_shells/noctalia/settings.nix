{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  wayland.windowManager.hyprland = {
    configType = "lua";
    settings = {
      mod = { _var = "SUPER"; };

      config = {
        general = {
          layout = "dwindle";
          gaps_in = 8;
          gaps_out = 16;
          border_size = 2;
          col = {
            active_border = { colors = [ "rgb(C9A0FF)" "rgb(8AB4F8)" ]; angle = 45; };
            inactive_border = "rgba(2E2F3866)";
          };
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
          vrr = 1;
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
          rounding = 7;
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

        animations.enabled = true;

        xwayland.force_zero_scaling = true;
      };

      curve = [
        { _args = [ "noctalia"    { type = "bezier"; points = [ [ 0.25 1    ] [ 0.5  1    ] ]; } ]; }
        { _args = [ "noctaliaOut" { type = "bezier"; points = [ [ 0.6  0    ] [ 0.6  1    ] ]; } ]; }
        { _args = [ "noctaliaIn"  { type = "bezier"; points = [ [ 0.2  0    ] [ 0.2  1    ] ]; } ]; }
        { _args = [ "wind"        { type = "bezier"; points = [ [ 0.05 0.9  ] [ 0.1  1.05 ] ]; } ]; }
      ];

      animation = [
        { leaf = "windowsIn";        enabled = true; speed = 5;  bezier = "noctalia";    style = "popin 60%"; }
        { leaf = "windowsOut";       enabled = true; speed = 4;  bezier = "noctaliaOut"; style = "popin 60%"; }
        { leaf = "windowsMove";      enabled = true; speed = 5;  bezier = "wind";        style = "slide"; }
        { leaf = "fadeIn";           enabled = true; speed = 3;  bezier = "noctalia"; }
        { leaf = "fadeOut";          enabled = true; speed = 3;  bezier = "noctaliaOut"; }
        { leaf = "fadeSwitch";       enabled = true; speed = 2;  bezier = "noctalia"; }
        { leaf = "fadeShadow";       enabled = true; speed = 6;  bezier = "noctalia"; }
        { leaf = "fadeDim";          enabled = true; speed = 3;  bezier = "noctalia"; }
        { leaf = "border";           enabled = true; speed = 8;  bezier = "noctalia"; }
        { leaf = "borderangle";      enabled = true; speed = 60; bezier = "noctalia";    style = "loop"; }
        { leaf = "workspaces";       enabled = true; speed = 5;  bezier = "noctalia";    style = "slidefadevert 20%"; }
        { leaf = "specialWorkspace"; enabled = true; speed = 5;  bezier = "noctalia";    style = "slidefadevert -20%"; }
      ];

      env = [
        { _args = [ "XCURSOR_THEME" "Bibata-Modern-Classic" ]; }
        { _args = [ "XCURSOR_SIZE"  "24"                    ]; }
      ];
    };
  };
}
