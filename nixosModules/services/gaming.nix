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
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      wineWowPackages.stable
      winetricks
      protontricks
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    users.users = lib.genAttrs cfg.extraUsers (user: {
      extraGroups = [ "gamemode" ];
    });
  };
}
