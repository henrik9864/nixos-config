{ inputs, config, ... }:
let inherit (config.flake.modules) nixos; in
{
  configurations.nixos.nixos-build.module = {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      inputs.vscode-server.nixosModules.default
      nixos.sshKeys
      nixos.nixCache
      nixos.ip
      (inputs.import-tree ../../hosts/build)
    ];
  };
}
