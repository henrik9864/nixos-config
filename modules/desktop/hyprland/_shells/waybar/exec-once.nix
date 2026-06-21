{ ... }: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "nm-applet &"
    "wl-paste --watch cliphist store &"
    "waybar &"
    "swaync &"
    "awww-daemon &"
    "awww img /home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg &"
    "udiskie --automount --notify --smart-tray &"
  ];
}
