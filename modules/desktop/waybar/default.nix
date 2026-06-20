{ config, ... }:
let
  active = config.desktopShell == "waybar";
  homeWaybar =
    if !active then { }
    else { pkgs, ... }: {
      imports = [
        ./_settings.nix
        ./_style.nix
        ./_scripts.nix
      ];
      programs.waybar.enable = true;
      home.packages = with pkgs; [
        hyprlock
        dunst
        rofi
        swaynotificationcenter
        wlogout
        waypaper
        awww
      ];
    };
in
{
  flake.modules.nixos.waybar = { ... }: {
    home-manager.users.henrik = homeWaybar;
  };
  flake.modules.homeManager.waybar = homeWaybar;
}
