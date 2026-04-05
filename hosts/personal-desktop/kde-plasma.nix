{
  config,
  pkgs,
  inputs,
  ...
}:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      General = {
        InputMethod = "";
      };
    };
  };

  services.desktopManager.plasma6.enable = true;

  services.xserver.enable = true;

  users.users.henrik.packages = with pkgs; [
    kdePackages.kate
  ];
}
