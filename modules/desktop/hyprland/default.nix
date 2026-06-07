{ inputs, ... }:
let
  homeHyprland = { pkgs, ... }: {
    imports = [
      ./_theme/settings.nix
      ./_theme/hw.nix
      ./_theme/binds.nix
      ./_theme/exec-once.nix
      ./_theme/windowrules.nix
    ];
    home.packages = [ pkgs.swww ];
    wayland.windowManager.hyprland.enable = true;
  };
in
{
  flake.modules.nixos.hyprland = import ./_nixos.nix inputs homeHyprland;
  flake.modules.homeManager.hyprland = homeHyprland;
}
