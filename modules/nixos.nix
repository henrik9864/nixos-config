{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _name: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        { _module.args.inputs = inputs; }
        config.flake.modules.nixos.base
        cfg.module
      ];
    }
  ) config.configurations.nixos;
}
