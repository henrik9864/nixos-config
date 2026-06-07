{ ... }:
let
  homeWaybar = { ... }: {
    imports = [
      ./_theme/settings.nix
      ./_theme/style.nix
    ];
    programs.waybar.enable = true;
  };
in
{
  flake.modules.nixos.waybar = { ... }: {
    home-manager.users.henrik = homeWaybar;
  };
  flake.modules.homeManager.waybar = homeWaybar;
}
