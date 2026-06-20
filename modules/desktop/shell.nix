{lib, ...}: {
  options.desktopShell = lib.mkOption {
    type = lib.types.enum ["waybar" "noctalia"];
    default = "noctalia";
    description = "Active desktop shell stack. Switch by changing this value and rebuilding.";
  };
}
