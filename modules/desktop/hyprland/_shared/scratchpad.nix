{ pkgs, lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
  k = key: mkLuaInline ''mod .. " + ${key}"'';
in
{
  home.packages = [ pkgs.libqalculate ];

  wayland.windowManager.hyprland.settings = {
    window_rule = [
      { match.class = "^(kitty-calc)$"; workspace = "special:calc silent"; }
      { match.class = "^(kitty-misc)$"; workspace = "special:misc silent"; }
      {
        match.class = "^(discord)$";
        workspace = "special:discord silent";
        float = true;
        size = "1280 800";
        center = true;
      }
    ];

    bind = [
      { _args = [ (k "O")         (mkLuaInline "hl.dsp.workspace.toggle_special(\"calc\")"   ) ]; }
      { _args = [ (k "SHIFT + O") (mkLuaInline "hl.dsp.exec_cmd(\"kitty --class kitty-calc -- qalc -set 'autocalc 1'\")") ]; }
      { _args = [ (k "B")         (mkLuaInline "hl.dsp.workspace.toggle_special(\"misc\")"   ) ]; }
      { _args = [ (k "I")         (mkLuaInline "hl.dsp.workspace.toggle_special(\"discord\")") ]; }
    ];

    on = [
      {
        _args = [
          "hyprland.start"
          (mkLuaInline ''
            function()
              hl.exec_cmd("kitty --class kitty-calc -- sh -c \"while true; do qalc -set 'autocalc 1'; sleep 0.1; done\"")
              hl.exec_cmd("kitty --class kitty-misc -- sh -c \"while true; do zsh; sleep 0.1; done\"")
              hl.exec_cmd("[workspace special:discord silent] discord")
            end
          '')
        ];
      }
    ];
  };
}
