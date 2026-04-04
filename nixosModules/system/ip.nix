{ config, lib, ... }:

let
  cfg = config.system.ip;
in
{
  options.system.ip = {
    enable = lib.mkEnableOption "static IP networking";

    address = lib.mkOption {
      type = lib.types.str;
      description = "Static IPv4 address to assign to this host";
      example = "192.168.1.11";
    };

    prefixLength = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Subnet prefix length (e.g. 24 for a /24 i.e. 255.255.255.0)";
      example = 24;
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      description = "Default gateway address";
      example = "192.168.1.1";
    };

    interface = lib.mkOption {
      type = lib.types.str;
      default = "eth0";
      description = "Network interface to configure (check with 'ip a' — Proxmox VirtIO NICs are often ens18 or enp6s18)";
      example = "ens18";
    };

    nameservers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      description = "List of DNS nameservers";
      example = [
        "192.168.1.1"
        "1.1.1.1"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Disable DHCP-based network management
    networking.useDHCP = false;
    networking.networkmanager.enable = lib.mkForce false;

    networking.interfaces.${cfg.interface} = {
      ipv4.addresses = [
        {
          address = cfg.address;
          prefixLength = cfg.prefixLength;
        }
      ];
    };

    networking.defaultGateway = cfg.gateway;
    networking.nameservers = cfg.nameservers;
  };
}
