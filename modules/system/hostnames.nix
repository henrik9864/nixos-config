{config, lib, ...}: let
  static = import ./_static-hosts.nix {inherit config lib;};
in {
  flake.modules.nixos.hostnames = {
    networking.hosts = lib.mapAttrs' (_: h:
      lib.nameValuePair h.config.system.ip.address [h.config.networking.hostName (static.shortName h)])
    static.hosts;
  };
}
