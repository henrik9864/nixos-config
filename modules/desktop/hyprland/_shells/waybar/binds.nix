{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
  k = key: mkLuaInline ''mod .. " + ${key}"'';
in
{
  wayland.windowManager.hyprland.settings = {
    config.binds = {
      scroll_event_delay = 100;
      movefocus_cycles_fullscreen = true;
    };

    bind = [
      { _args = [ (k "RETURN")         (mkLuaInline "hl.dsp.exec_cmd(\"kitty\")")                       ]; }
      { _args = [ (k "Q")              (mkLuaInline "hl.dsp.window.close()")                             ]; }
      { _args = [ (k "F")              (mkLuaInline "hl.dsp.window.fullscreen()")                        ]; }
      { _args = [ (k "SHIFT + F")      (mkLuaInline "hl.dsp.window.fullscreen(1)")                      ]; }
      { _args = [ (k "V")              (mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")      ]; }
      { _args = [ (k "D")              (mkLuaInline "hl.dsp.exec_cmd(\"rofi -show drun\")")              ]; }
      { _args = [ (k "ESCAPE")         (mkLuaInline "hl.dsp.exec_cmd(\"hyprlock\")")                    ]; }
      { _args = [ (k "SHIFT + ESCAPE") (mkLuaInline "hl.dsp.exec_cmd(\"wlogout\")")                     ]; }
      { _args = [ (k "P")              (mkLuaInline "hl.dsp.window.pseudo()")                            ]; }
      { _args = [ (k "X")              (mkLuaInline "hl.dsp.layout(\"togglesplit\")")                    ]; }
      { _args = [ (k "E")              (mkLuaInline "hl.dsp.exec_cmd(\"nemo\")")                         ]; }
      { _args = [ (k "N")              (mkLuaInline "hl.dsp.exec_cmd(\"swaync-client -t -sw\")")         ]; }
      { _args = [ (k "W")              (mkLuaInline "hl.dsp.exec_cmd(\"waypaper\")")                     ]; }
      { _args = [ (k "SHIFT + R")      (mkLuaInline "hl.dsp.exit()")                                    ]; }
      # screenshot
      { _args = [ "Print"              (mkLuaInline "hl.dsp.exec_cmd(\"grim -g \\\"$(slurp)\\\" - | wl-copy\")") ]; }
      { _args = [ (k "PRINT")          (mkLuaInline "hl.dsp.exec_cmd(\"grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png\")") ]; }
      # workspaces
      { _args = [ (k "1") (mkLuaInline "hl.dsp.focus({ workspace = 1  })") ]; }
      { _args = [ (k "2") (mkLuaInline "hl.dsp.focus({ workspace = 2  })") ]; }
      { _args = [ (k "3") (mkLuaInline "hl.dsp.focus({ workspace = 3  })") ]; }
      { _args = [ (k "4") (mkLuaInline "hl.dsp.focus({ workspace = 4  })") ]; }
      { _args = [ (k "5") (mkLuaInline "hl.dsp.focus({ workspace = 5  })") ]; }
      { _args = [ (k "6") (mkLuaInline "hl.dsp.focus({ workspace = 6  })") ]; }
      { _args = [ (k "7") (mkLuaInline "hl.dsp.focus({ workspace = 7  })") ]; }
      { _args = [ (k "8") (mkLuaInline "hl.dsp.focus({ workspace = 8  })") ]; }
      { _args = [ (k "9") (mkLuaInline "hl.dsp.focus({ workspace = 9  })") ]; }
      { _args = [ (k "0") (mkLuaInline "hl.dsp.focus({ workspace = 10 })") ]; }
      { _args = [ (k "SHIFT + 1") (mkLuaInline "hl.dsp.window.move({ workspace = 1,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 2") (mkLuaInline "hl.dsp.window.move({ workspace = 2,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 3") (mkLuaInline "hl.dsp.window.move({ workspace = 3,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 4") (mkLuaInline "hl.dsp.window.move({ workspace = 4,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 5") (mkLuaInline "hl.dsp.window.move({ workspace = 5,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 6") (mkLuaInline "hl.dsp.window.move({ workspace = 6,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 7") (mkLuaInline "hl.dsp.window.move({ workspace = 7,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 8") (mkLuaInline "hl.dsp.window.move({ workspace = 8,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 9") (mkLuaInline "hl.dsp.window.move({ workspace = 9,  follow = false })") ]; }
      { _args = [ (k "SHIFT + 0") (mkLuaInline "hl.dsp.window.move({ workspace = 10, follow = false })") ]; }
      # window movement
      { _args = [ (k "SHIFT + left" ) (mkLuaInline "hl.dsp.window.move({ direction = \"left\"  })") ]; }
      { _args = [ (k "SHIFT + right") (mkLuaInline "hl.dsp.window.move({ direction = \"right\" })") ]; }
      { _args = [ (k "SHIFT + up"   ) (mkLuaInline "hl.dsp.window.move({ direction = \"up\"    })") ]; }
      { _args = [ (k "SHIFT + down" ) (mkLuaInline "hl.dsp.window.move({ direction = \"down\"  })") ]; }
      { _args = [ (k "SHIFT + H")     (mkLuaInline "hl.dsp.window.move({ direction = \"left\"  })") ]; }
      { _args = [ (k "SHIFT + J")     (mkLuaInline "hl.dsp.window.move({ direction = \"down\"  })") ]; }
      { _args = [ (k "SHIFT + K")     (mkLuaInline "hl.dsp.window.move({ direction = \"up\"    })") ]; }
      { _args = [ (k "SHIFT + L")     (mkLuaInline "hl.dsp.window.move({ direction = \"right\" })") ]; }
      { _args = [ (k "CTRL + left" ) (mkLuaInline "hl.dsp.window.resize({ x = -80, y = 0,   relative = true })") ]; }
      { _args = [ (k "CTRL + right") (mkLuaInline "hl.dsp.window.resize({ x = 80,  y = 0,   relative = true })") ]; }
      { _args = [ (k "CTRL + up"   ) (mkLuaInline "hl.dsp.window.resize({ x = 0,   y = -80, relative = true })") ]; }
      { _args = [ (k "CTRL + down" ) (mkLuaInline "hl.dsp.window.resize({ x = 0,   y = 80,  relative = true })") ]; }
      # focus (works through fullscreen inhibitors)
      { _args = [ (k "left" ) (mkLuaInline "hl.dsp.focus({ direction = \"left\"  })") { locked = true; } ]; }
      { _args = [ (k "right") (mkLuaInline "hl.dsp.focus({ direction = \"right\" })") { locked = true; } ]; }
      { _args = [ (k "up"   ) (mkLuaInline "hl.dsp.focus({ direction = \"up\"    })") { locked = true; } ]; }
      { _args = [ (k "down" ) (mkLuaInline "hl.dsp.focus({ direction = \"down\"  })") { locked = true; } ]; }
      { _args = [ (k "H")     (mkLuaInline "hl.dsp.focus({ direction = \"left\"  })") { locked = true; } ]; }
      { _args = [ (k "J")     (mkLuaInline "hl.dsp.focus({ direction = \"down\"  })") { locked = true; } ]; }
      { _args = [ (k "K")     (mkLuaInline "hl.dsp.focus({ direction = \"up\"    })") { locked = true; } ]; }
      { _args = [ (k "L")     (mkLuaInline "hl.dsp.focus({ direction = \"right\" })") { locked = true; } ]; }
      # media
      { _args = [ "XF86AudioPlay"         (mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")") { locked = true; } ]; }
      { _args = [ "XF86AudioNext"         (mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")        { locked = true; } ]; }
      { _args = [ "XF86AudioPrev"         (mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")    { locked = true; } ]; }
      { _args = [ "XF86AudioRaiseVolume"  (mkLuaInline "hl.dsp.exec_cmd(\"pamixer -i 5\")")          { locked = true; } ]; }
      { _args = [ "XF86AudioLowerVolume"  (mkLuaInline "hl.dsp.exec_cmd(\"pamixer -d 5\")")          { locked = true; } ]; }
      { _args = [ "XF86AudioMute"         (mkLuaInline "hl.dsp.exec_cmd(\"pamixer -t\")")            { locked = true; } ]; }
      { _args = [ "XF86MonBrightnessUp"   (mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set 5%+\")") { locked = true; } ]; }
      { _args = [ "XF86MonBrightnessDown" (mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set 5%-\")") { locked = true; } ]; }
      { _args = [ (k "mouse_down") (mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })") ]; }
      { _args = [ (k "mouse_up"  ) (mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })") ]; }
      # mouse drag/resize
      { _args = [ (k "mouse:272") (mkLuaInline "hl.dsp.window.drag()"  ) { mouse = true; } ]; }
      { _args = [ (k "mouse:273") (mkLuaInline "hl.dsp.window.resize()") { mouse = true; } ]; }
    ];
  };
}
