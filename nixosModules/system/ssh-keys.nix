{ config, lib, ... }:

let
  cfg = config.system.sshKeys;
in
{
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
      builtins.attrValues (
        builtins.mapAttrs (name: _: ../../../keys/${name}) (builtins.readDir ../../../keys)
      );
  };
}
