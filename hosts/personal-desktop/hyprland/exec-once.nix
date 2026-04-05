{ ... }:
{
  wayland.windowManager.hyprland.settings.exec-once = [
    "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "nm-applet &"
    "wl-paste --watch cliphist store &"
    "waybar &"
    "swaync &"
    "waypaper --restore &"
    "udiskie --automount --notify --smart-tray &"
    "[workspace 9 silent] discord"
    "hyprsession"
  ];
}
