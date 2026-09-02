{ inputs, config, ... }:
let
  shells = {
    waybar = ./_shells/waybar;
    noctalia = ./_shells/noctalia;
  };
  homeHyprland = { ... }: {
    imports = [
      shells.${config.desktopShell}
      ./_shared/hw.nix
      ./_shared/scratchpad.nix
      ./_shared/dev-windows.nix
    ];
    wayland.windowManager.hyprland.enable = true;
  };
in
{
  flake.modules.nixos.hyprland = import ./_nixos.nix inputs homeHyprland;
  flake.modules.homeManager.hyprland = homeHyprland;
}
