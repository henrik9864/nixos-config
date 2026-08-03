{...}: let
  shared = import ./_shared.nix;

  homeZsh = {lib, ...}: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      shellAliases = shared.aliases;
      initContent = lib.mkOrder 1200 shared.promptInit;
      oh-my-zsh = {
        enable = true;
        inherit (shared) theme plugins;
      };
    };
  };

  nixosZsh = {
    config,
    lib,
    ...
  }: let
    cfg = config.system.zsh;
  in {
    options.system.zsh = {
      enable = lib.mkEnableOption "Henrik's shared zsh configuration";

      homeManagerUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["henrik"];
        description = ''
          Users who get the shared config through home-manager. Only used when
          the `zshHome` module is imported instead of `zsh`.
        '';
      };

      homeManaged = lib.mkOption {
        type = lib.types.bool;
        default = false;
        internal = true;
        description = "Set by the `zshHome` module; keeps the config out of /etc/zshrc.";
      };
    };

    config = lib.mkIf cfg.enable (lib.mkMerge [
      {programs.zsh.enable = true;}

      (lib.mkIf (!cfg.homeManaged) {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        programs.zsh = {
          shellAliases = shared.aliases;
          promptInit = shared.promptInit;
          ohMyZsh = {
            enable = true;
            inherit (shared) theme plugins;
          };
        };
      })
    ]);
  };
in {
  flake.modules.homeManager.zsh = homeZsh;

  flake.modules.nixos.zsh = nixosZsh;

  flake.modules.nixos.zshHome = {
    config,
    lib,
    ...
  }: {
    imports = [nixosZsh];

    system.zsh.homeManaged = true;

    home-manager.users =
      lib.genAttrs config.system.zsh.homeManagerUsers
      (_: {imports = lib.optional config.system.zsh.enable homeZsh;});
  };
}
