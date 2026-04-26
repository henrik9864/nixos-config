{ config, lib, ... }:

let
  cfg = config.system.nixCache;
in
{
  options.system.nixCache = {
    enable = lib.mkEnableOption "personal Harmonia nix binary cache";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "http://192.168.10.62:5000" ];
      trusted-public-keys = [ "nixos-nix-cache-1:h/ntgEWLzcIlVUL9EiTaH03UTct9RL8FECcG1ytdhwU=" ];
    };
  };
}
