{config, lib, ...}: let
  static = import ./_static-hosts.nix {inherit config lib;};
in {
  flake.modules.nixos.deploy = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "deploy";
        text = ''
          usage() {
            echo "usage: deploy <host> [switch|boot|test|dry-activate] [extra nixos-rebuild args]"
            echo "hosts: ${lib.concatStringsSep " " (lib.mapAttrsToList (_: static.shortName) static.hosts)}"
            exit 1
          }

          [ $# -ge 1 ] || usage
          host=$1
          shift
          action=switch
          if [ $# -ge 1 ] && [[ $1 != -* ]]; then
            action=$1
            shift
          fi

          case $host in
          ${lib.concatStrings (lib.mapAttrsToList (name: h: ''
              ${h.config.networking.hostName}|${static.shortName h}) flake=${name}; target=${h.config.networking.hostName} ;;
            '')
            static.hosts)}  *) usage ;;
          esac

          exec nixos-rebuild "$action" \
            --flake "''${NIXOS_CONFIG_DIR:-$HOME/nixos-config}#$flake" \
            --target-host "$target" --sudo "$@"
        '';
      })
    ];
  };
}
