{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  wayland.windowManager.hyprland.settings.on = [
    {
      _args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            hl.exec_cmd("dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            hl.exec_cmd("nm-applet &")
            hl.exec_cmd("wl-paste --watch cliphist store &")
            hl.exec_cmd("waybar &")
            hl.exec_cmd("swaync &")
            hl.exec_cmd("awww-daemon &")
            hl.exec_cmd("awww img /home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg &")
            hl.exec_cmd("udiskie --automount --notify --smart-tray &")
          end
        '')
      ];
    }
  ];
}
