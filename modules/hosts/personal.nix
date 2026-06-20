{ inputs, config, ... }:
let inherit (config.flake.modules) nixos; in
{
  configurations.nixos.nixos-personal.module =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = "x86_64-linux";
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nix-index-database.nixosModules.nix-index
        inputs.nicotine.nixosModules.nicotine
        inputs.nicotine.nixosModules.eveguru
        inputs.nixvim.nixosModules.default
        nixos.hyprland
        nixos.waybar
        nixos.noctalia
        nixos.vim
        nixos.gaming
        nixos.llm
        nixos.openWebui
        nixos.searxng
        nixos.hermes
        nixos.networkStorage
        nixos.dotnet
        nixos.remoteBuild
        (inputs.import-tree ../../hosts/personal-desktop)
      ];
      _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      environment.systemPackages = [ pkgs.sbctl ];
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
}
