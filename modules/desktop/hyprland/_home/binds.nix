{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
  k = key: mkLuaInline ''mod .. " + ${key}"'';

  bind = key: action: {_args = [key (mkLuaInline action)];};
  bindLocked = key: action: {_args = [key (mkLuaInline action) {locked = true;}];};
  bindMouse = key: action: {_args = [key (mkLuaInline action) {mouse = true;}];};

  exec = cmd: "hl.dsp.exec_cmd(${builtins.toJSON cmd})";
  noctalia = args: exec "noctalia msg ${args}";

  # arrow key + vim key for each direction
  directions = [
    { arrow = "left";  vim = "H"; dir = "left";  }
    { arrow = "down";  vim = "J"; dir = "down";  }
    { arrow = "up";    vim = "K"; dir = "up";    }
    { arrow = "right"; vim = "L"; dir = "right"; }
  ];
  perDirection = mkBinds: lib.concatMap (d: [(mkBinds d.arrow d.dir) (mkBinds d.vim d.dir)]) directions;

  # keys 1..9, 0 -> workspaces 1..10; numpad by keycode so it works regardless of numlock/shift
  numpadCodes = [87 88 89 83 84 85 79 80 81 90];
  workspaces = lib.genList (i: {
    key = toString (lib.mod (i + 1) 10);
    numpad = "code:${toString (builtins.elemAt numpadCodes i)}";
    ws = toString (i + 1);
  }) 10;
in {
  wayland.windowManager.hyprland.settings = {
    config.binds = {
      scroll_event_delay = 100;
      movefocus_cycles_fullscreen = true;
    };

    bind =
      # apps
      [
        (bind (k "RETURN") (exec "kitty"))
        (bind (k "E") (exec "nemo"))
        (bind (k "D") (noctalia "panel-toggle launcher"))
      ]

      # window state
      ++ [
        (bind (k "Q") "hl.dsp.window.close()")
        (bind (k "F") "hl.dsp.window.fullscreen()")
        (bind (k "SHIFT + F") "hl.dsp.window.fullscreen(1)")
        (bind (k "V") ''hl.dsp.window.float({ action = "toggle" })'')
        (bind (k "P") "hl.dsp.window.pseudo()")
        (bind (k "X") ''hl.dsp.layout("togglesplit")'')
      ]

      # focus (works through fullscreen inhibitors)
      ++ perDirection (key: dir: bindLocked (k key) ''hl.dsp.focus({ direction = "${dir}" })'')

      # move window
      ++ perDirection (key: dir: bind (k "SHIFT + ${key}") ''hl.dsp.window.move({ direction = "${dir}" })'')

      # resize window
      ++ [
        (bind (k "CTRL + left") "hl.dsp.window.resize({ x = -80, y = 0, relative = true })")
        (bind (k "CTRL + right") "hl.dsp.window.resize({ x = 80, y = 0, relative = true })")
        (bind (k "CTRL + up") "hl.dsp.window.resize({ x = 0, y = -80, relative = true })")
        (bind (k "CTRL + down") "hl.dsp.window.resize({ x = 0, y = 80, relative = true })")
      ]

      # workspaces
      ++ map (w: bind (k w.key) "hl.dsp.focus({ workspace = ${w.ws} })") workspaces
      ++ map (w: bind (k "SHIFT + ${w.key}") "hl.dsp.window.move({ workspace = ${w.ws}, follow = false })") workspaces
      ++ map (w: bind (k w.numpad) "hl.dsp.focus({ workspace = ${w.ws} })") workspaces
      ++ map (w: bind (k "SHIFT + ${w.numpad}") "hl.dsp.window.move({ workspace = ${w.ws}, follow = false })") workspaces
      ++ [
        (bind (k "mouse_down") ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind (k "mouse_up") ''hl.dsp.focus({ workspace = "e+1" })'')
        (bind (k "ALT + left") ''hl.dsp.workspace.move({ monitor = "l" })'')
        (bind (k "ALT + right") ''hl.dsp.workspace.move({ monitor = "r" })'')
      ]

      # noctalia shell
      ++ [
        (bind (k "N") (noctalia "panel-toggle control-center notifications"))
        (bind (k "C") (noctalia "panel-toggle control-center"))
        (bind (k "W") (noctalia "panel-toggle wallpaper"))
        (bind (k "ESCAPE") (noctalia "session lock"))
        (bind (k "SHIFT + ESCAPE") (noctalia "panel-toggle session"))
        (bind (k "SHIFT + R") "hl.dsp.exit()")
      ]

      # screenshot
      ++ [
        (bind "Print" (exec ''grim -g "$(slurp)" - | wl-copy''))
        (bind (k "PRINT") (exec "grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"))
      ]

      # media / hardware keys
      ++ [
        (bindLocked "XF86AudioPlay" (exec "playerctl play-pause"))
        (bindLocked "XF86AudioNext" (exec "playerctl next"))
        (bindLocked "XF86AudioPrev" (exec "playerctl previous"))
        (bindLocked "XF86AudioRaiseVolume" (exec "pamixer -i 5"))
        (bindLocked "XF86AudioLowerVolume" (exec "pamixer -d 5"))
        (bindLocked "XF86AudioMute" (exec "pamixer -t"))
        (bindLocked "XF86MonBrightnessUp" (exec "brightnessctl set 5%+"))
        (bindLocked "XF86MonBrightnessDown" (exec "brightnessctl set 5%-"))
      ]

      # mouse drag / resize
      ++ [
        (bindMouse (k "mouse:272") "hl.dsp.window.drag()")
        (bindMouse (k "mouse:273") "hl.dsp.window.resize()")
      ];
  };
}
