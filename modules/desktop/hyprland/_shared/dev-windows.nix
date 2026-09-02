{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      # Hengine sets no app_id/class yet, so match on title
      {
        match.title = "^(Hengine)";
        float = true;
        center = true;
      }
    ];
  };
}
