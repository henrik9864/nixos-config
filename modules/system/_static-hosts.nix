{config, lib}: {
  hosts = lib.filterAttrs (_: h: h.config.system.ip.enable or false) config.flake.nixosConfigurations;
  shortName = h: lib.removePrefix "nixos-" h.config.networking.hostName;
}
