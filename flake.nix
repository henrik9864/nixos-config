{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nicotine.url = "path:/home/henrik/projects/nicotine-nix";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.2";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05"; # pinned to match nixpkgs
      inputs.nixpkgs.follows = "nixpkgs"; # use same nixpkgs
    };
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      flake.nixosConfigurations = {
        nixos-build = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            inputs.vscode-server.nixosModules.default
            (inputs.import-tree ./hosts/build)
            (inputs.import-tree ./nixosModules)
          ];
        };
        nixos-proxmox-template = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            (inputs.import-tree ./hosts/proxmox-template)
            (inputs.import-tree ./nixosModules)
          ];
        };
        nixos-nix-cache = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            (inputs.import-tree ./hosts/nix-cache)
            (inputs.import-tree ./nixosModules)
          ];
        };
        nixos-docker = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            inputs.vscode-server.nixosModules.default
            (inputs.import-tree ./hosts/docker)
            (inputs.import-tree ./nixosModules)
          ];
        };
        nixos-personal = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-unstable = import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nix-index-database.nixosModules.nix-index
            inputs.nicotine.nixosModules.nicotine
            inputs.nicotine.nixosModules.eveguru
            inputs.nixvim.nixosModules.default
            (inputs.import-tree ./hosts/personal-desktop)
            (inputs.import-tree ./nixosModules)
            (
              {
                pkgs,
                lib,
                ...
              }: {
                environment.systemPackages = [pkgs.sbctl];
                boot.loader.systemd-boot.enable = lib.mkForce false;
                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )
          ];
        };
      };
    };
}
