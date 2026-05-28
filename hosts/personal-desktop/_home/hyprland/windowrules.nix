{...}: {
  wayland.windowManager.hyprland.extraConfig = ''
    windowrule = float yes, match:class ^(discord)$
    windowrule = size 1280 800, match:class ^(discord)$
    windowrule = center yes, match:class ^(discord)$
  '';
}
