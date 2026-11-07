{inputs, config, lib, ...}: let
  staticHosts = lib.filter (c: c.system.ip.enable or false) (
    map (h: h.config) (lib.attrValues config.flake.nixosConfigurations)
  );
in {
  flake.modules.nixos.base = {
    imports = [inputs.nix-index-database.nixosModules.nix-index];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    programs.nix-index-database.comma.enable = true;

    environment.enableAllTerminfo = true;

    networking.hosts = lib.listToAttrs (map (c: {
        name = c.system.ip.address;
        value = [c.networking.hostName (lib.removePrefix "nixos-" c.networking.hostName)];
      })
      staticHosts);
  };
}
