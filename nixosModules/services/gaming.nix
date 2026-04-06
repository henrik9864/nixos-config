{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.gaming;
in
{
  options.services.gaming = {
    enable = lib.mkEnableOption "gaming support";

    extraUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users to add to the gamemode group.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Steam with Proton/Wine support
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extraCompatPackages = with pkgs; [
        proton-ge-bin # Community Proton build with extra patches
      ];
    };

    # Gamemode - lets games request performance optimisations
    programs.gamemode.enable = true;

    # Gamescope - Valve's micro-compositor for games
    programs.gamescope.enable = true;

    # Wine and related tools
    environment.systemPackages = with pkgs; [
      wineWowPackages.stable # 32+64-bit Wine
      winetricks # Wine prefix helper
      protontricks # Winetricks wrapper for Proton prefixes
    ];

    # 32-bit graphics support (required for many games/Wine)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    users.users = lib.genAttrs cfg.extraUsers (user: {
      extraGroups = [ "gamemode" ];
    });
  };
}
