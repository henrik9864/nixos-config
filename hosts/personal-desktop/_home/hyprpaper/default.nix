{ pkgs, lib, config, ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg" ];
      wallpaper = [
        "HDMI-A-1,/home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg"
        "DP-1,/home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg"
        "DP-2,/home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg"
      ];
    };
  };
}
