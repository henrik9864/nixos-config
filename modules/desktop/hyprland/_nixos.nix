inputs: homeHyprland:
{ config, pkgs, pkgs-unstable ? pkgs, ... }:
let
  nvidiaPackage =
    (pkgs-unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.latest;
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = nvidiaPackage;
    powerManagement.enable = true;
  };
  hardware.graphics.enable = true;

  services.getty.autologinUser = "henrik";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  environment.systemPackages = with pkgs; [
    kitty hyprpaper hypridle libnotify
    grim slurp wl-clipboard
    brightnessctl pamixer
    kdePackages.dolphin polkit_gnome
    btop fastfetch
  ];

  home-manager.users.henrik = homeHyprland;
}
