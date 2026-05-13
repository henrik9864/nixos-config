{...}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    monitor = [
      "HDMI-A-1,2560x1440@74.97,0x0,1"
      "DP-2,2560x1440@239.76,2560x0,1"
      "DP-3,2560x1440@74.97,5120x0,1"
    ];

    workspace = [
      "1, monitor:HDMI-A-1, default:true, floating:1"
      "2, monitor:DP-2, default:true, floating:1"
      "3, monitor:DP-3, default:true, floating:1"
    ];

    input = {
      kb_layout = "no";
      kb_variant = "nodeadkeys";
      kb_options = "";

      repeat_delay = 300;
      numlock_by_default = true;

      follow_mouse = 0;
      mouse_refocus = 0;
      float_switch_override_focus = 0;
      accel_profile = "flat";
      sensitivity = 1;

      touchpad = {
        disable_while_typing = false;
        natural_scroll = true;
      };
    };
  };
}
