{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixos-nix-cache";

  system.sshKeys.enable = true;

  system.ip = {
    enable = true;
    interface = "ens18";
    address = "192.168.10.62";
    gateway = "192.168.10.1";
  };

  time.timeZone = "Europe/Oslo";

  users.users.henrik = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # Harmonia binary cache server
  # On first deploy, generate a signing key:
  #   nix-store --generate-binary-cache-key nixos-nix-cache-1 /etc/harmonia/secret-key /etc/harmonia/public-key
  # Then add the public key to your other machines' nix.settings.trusted-public-keys.
  # To use this cache on other machines, add to their configuration:
  #   nix.settings.substituters = [ "http://192.168.10.62:5000" ];
  #   nix.settings.trusted-public-keys = [ "<contents of /etc/harmonia/public-key>" ];
  services.harmonia = {
    enable = true;
    signKeyPaths = [ "/etc/harmonia/secret-key" ];
    settings.bind = "0.0.0.0:5000";
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];

  # Allow the harmonia user to access the nix store
  nix.settings.allowed-users = [ "harmonia" ];

  system.stateVersion = "25.11";
}
