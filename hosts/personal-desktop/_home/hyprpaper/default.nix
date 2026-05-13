{...}: {
  imports = [
  ];

  services.hyprpaper.enable = true;

  # TODO: Move to separate file
  services.hyprpaper = {
    settings = {
      preload = ["~/walls/otherWallpaper/gruvbox/forest_bridge.jpg"];
      wallpaper = [
        "HDMI-A-1,~/walls/otherWallpaper/gruvbox/forest_bridge.jpg"
        "DP-2,~/walls/otherWallpaper/gruvbox/forest_bridge.jpg"
        "DP-3,~/walls/otherWallpaper/gruvbox/forest_bridge.jpg"
      ];
    };
  };
}
