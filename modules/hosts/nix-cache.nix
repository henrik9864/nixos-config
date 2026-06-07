{ inputs, config, ... }:
let inherit (config.flake.modules) nixos; in
{
  configurations.nixos.nixos-nix-cache.module = {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      nixos.sshKeys
      nixos.ip
      (inputs.import-tree ../../hosts/nix-cache)
    ];
  };
}
