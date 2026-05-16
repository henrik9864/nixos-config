{...}: {
  imports = [
  ];

  services.hyprpaper.enable = true;

  # TODO: Move to separate file
  services.hyprpaper = {
    settings = {
      preload = ["~/walls/otherWallpaper/space_kurz/space_earth.jpg"];
      wallpaper = [
        "HDMI-A-1,~/walls/otherWallpaper/space_kurz/space_earth.jpg"
        "DP-1,~/walls/otherWallpaper/space_kurz/space_earth.jpg"
        "DP-2,~/walls/otherWallpaper/space_kurz/space_earth.jpg"
      ];
    };
  };
}
