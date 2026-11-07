{ ... }:
{
  flake.modules.nixos.sshKeys = { config, lib, ... }: let
    cfg = config.system.sshKeys;
    userKeys = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".pub" name) (builtins.readDir ../../keys);
  in {
    options.system.sshKeys = {
      enable = lib.mkEnableOption "load SSH authorized keys from the keys/ directory at the repo root";
      user = lib.mkOption {
        type = lib.types.str;
        default = "henrik";
        description = "The user to add the SSH keys to";
      };
    };
    config = lib.mkIf cfg.enable {
      users.users.${cfg.user}.openssh.authorizedKeys.keyFiles =
        map (name: ../../keys/${name}) (builtins.attrNames userKeys);

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };
  };
}
