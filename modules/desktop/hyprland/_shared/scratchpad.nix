{pkgs, ...}: {
  home.packages = [pkgs.libqalculate];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      # calc scratchpad (tiled — multiple calcs split the workspace)
      windowrule = workspace special:calc silent, match:class ^(kitty-calc)$

      # misc scratchpad (general-purpose terminal)
      windowrule = workspace special:misc silent, match:class ^(kitty-misc)$

      # discord scratchpad
      windowrule = workspace special:discord silent, match:class ^(discord)$
      windowrule = float yes, match:class ^(discord)$
      windowrule = size 1280 800, match:class ^(discord)$
      windowrule = center yes, match:class ^(discord)$
    '';

    settings = {
      bind = [
        "$mod, o, togglespecialworkspace, calc"
        "$mod SHIFT, o, exec, kitty --class kitty-calc -- qalc -set 'autocalc 1'"
        "$mod, b, togglespecialworkspace, misc"
        "$mod, i, togglespecialworkspace, discord"
      ];
      exec-once = [
        ''kitty --class kitty-calc -- sh -c "while true; do qalc -set 'autocalc 1'; sleep 0.1; done"''
        ''kitty --class kitty-misc -- sh -c "while true; do zsh; sleep 0.1; done"''
        "discord"
      ];
    };
  };
}
