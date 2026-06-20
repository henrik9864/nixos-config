{ inputs, config, lib, ... }:
let
  active = config.desktopShell == "noctalia";
  homeNoctalia =
    if !active then { }
    else {
      imports = [ inputs.noctalia.homeModules.default ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          shell = {
            font_family = "JetBrainsMono Nerd Font";
            corner_radius_scale = 1.5;
          };
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
            templates = {
              enable_builtin_templates = true;
              builtin_ids = [ "btop" ];
            };
          };
          bar.main = {
            position = "bottom";
            thickness = 38;
            margin_h = 200;
            margin_v = 12;
            radius = 16;
            background_opacity = 0.85;
            capsule = true;
            shadow = true;
          };
          wallpaper.default.path = "/home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg";
        };
      };
    };
in
{
  flake.modules.nixos.noctalia = { lib, ... }: {
    home-manager.users.henrik = homeNoctalia;
    hardware.bluetooth.enable = lib.mkIf active true;
    services.upower.enable = lib.mkIf active true;
    services.power-profiles-daemon.enable = lib.mkIf active true;
  };
  flake.modules.homeManager.noctalia = homeNoctalia;
}
