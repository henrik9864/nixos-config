{...}: {
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      {
        match.title = "^(Hengine)";
        float = true;
        center = true;
      }
    ];
  };
}
