{ inputs, config, ... }:
let inherit (config.flake.modules) nixos; in
{
  configurations.nixos.nixos-proxmox-template.module = {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      nixos.sshKeys
      (inputs.import-tree ../../hosts/proxmox-template)
    ];
  };
}
