{ ... }: {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      { output = "HDMI-A-1"; mode = "2560x1440@74.97";  position = "0x0";    scale = 1; }
      { output = "DP-2";     mode = "2560x1440@239.76"; position = "2560x0"; scale = 1; }
      { output = "DP-3";     mode = "2560x1440@74.97";  position = "5120x0"; scale = 1; }
    ];

    workspace_rule = [
      { workspace = "1"; monitor = "HDMI-A-1"; default = true; }
      { workspace = "2"; monitor = "DP-2";     default = true; }
      { workspace = "3"; monitor = "DP-3";     default = true; }
    ];

    config.input = {
      kb_layout = "no";
      kb_variant = "nodeadkeys";
      kb_options = "";
      repeat_delay = 300;
      numlock_by_default = true;
      follow_mouse = 0;
      mouse_refocus = false;
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
