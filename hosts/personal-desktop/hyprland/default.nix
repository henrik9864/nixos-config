{ ... }:
{
  imports = [
    ./settings.nix
    ./exec-once.nix
    ./binds.nix
    ./windowrules.nix
  ];

  wayland.windowManager.hyprland.enable = true;
}
