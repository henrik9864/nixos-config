{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    binds = {
      scroll_event_delay = 100;
      movefocus_cycles_fullscreen = true;
    };

    bind = [
      "$mod, Return, exec, kitty"
      "$mod, Q, killactive,"
      "$mod, F, fullscreen, 0"
      "$mod SHIFT, F, fullscreen, 1"
      "$mod, V, togglefloating,"
      "$mod, D, exec, rofi -show drun"
      "$mod, Escape, exec, hyprlock"
      "$mod SHIFT, Escape, exec, wlogout"
      "$mod, P, pseudo,"
      "$mod, X, togglesplit,"
      "$mod, E, exec, nemo"
      "$mod, N, exec, swaync-client -t -sw"
      "$mod, W, exec, waypaper"
      "$mod SHIFT, R, exec, hyprctl dispatch exit"

      # screenshot
      ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      "$mod, Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"

      # switch focus
      "$mod, left,  movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up,    movefocus, u"
      "$mod, down,  movefocus, d"
      "$mod, h, movefocus, l"
      "$mod, j, movefocus, d"
      "$mod, k, movefocus, u"
      "$mod, l, movefocus, r"

      # switch workspace
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      "$mod SHIFT, 1, movetoworkspacesilent, 1"
      "$mod SHIFT, 2, movetoworkspacesilent, 2"
      "$mod SHIFT, 3, movetoworkspacesilent, 3"
      "$mod SHIFT, 4, movetoworkspacesilent, 4"
      "$mod SHIFT, 5, movetoworkspacesilent, 5"
      "$mod SHIFT, 6, movetoworkspacesilent, 6"
      "$mod SHIFT, 7, movetoworkspacesilent, 7"
      "$mod SHIFT, 8, movetoworkspacesilent, 8"
      "$mod SHIFT, 9, movetoworkspacesilent, 9"
      "$mod SHIFT, 0, movetoworkspacesilent, 10"

      # window control
      "$mod SHIFT, left,  movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up,    movewindow, u"
      "$mod SHIFT, down,  movewindow, d"
      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, j, movewindow, d"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, l, movewindow, r"

      "$mod CTRL, left,  resizeactive, -80 0"
      "$mod CTRL, right, resizeactive, 80 0"
      "$mod CTRL, up,    resizeactive, 0 -80"
      "$mod CTRL, down,  resizeactive, 0 80"

      # media
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

      "$mod, mouse_down, workspace, e-1"
      "$mod, mouse_up, workspace, e+1"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
