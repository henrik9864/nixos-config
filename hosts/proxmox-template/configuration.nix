# Proxmox NixOS Template
#
# How to build and deploy:
#
# 1. Build the qcow image (from nixos-config directory):
#      nix run github:nix-community/nixos-generators -- --format qcow --flake .#nixos-proxmox-template
#
# 2. Copy image to Proxmox:
#      scp $(readlink -f result) root@<proxmox-ip>:/tmp/nixos-template.qcow2
#
# 3. On Proxmox, create and configure the template VM (replace 9000 and local-lvm as needed):
#      qm create 9000 --name nixos-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0 --ostype l26 --bios seabios
#      qm importdisk 9000 /tmp/nixos-template.qcow2 local-lvm
#      qm set 9000 --virtio0 local-lvm:vm-9000-disk-0
#      qm set 9000 --boot order=virtio0
#      qm set 9000 --ide2 local-lvm:cloudinit
#      qm template 9000
#
# 4. Clone the template for each new VM:
#      qm clone 9000 <new-id> --name <hostname> --full
#      qm start <new-id>
#
# 5. To delete and recreate the template:
#      qm destroy 9000 --purge
#
# Notes:
#   - SSH keys are loaded from the keys/ directory at the repo root.
#     Add public key files there and commit them before building.
#   - The "no EFI environment" warning from cloud-init on boot is harmless.
#   - cloud-init handles hostname and network config on cloned VMs via Proxmox UI.

{
  config,
  lib,
  pkgs,
  ...
}: {
  system.sshKeys.enable = true;

  networking.hostName = "nixos-proxmox";

  networking.useDHCP = true;

  services.qemuGuest.enable = true;

  services.cloud-init = {
    enable = true;
    network.enable = true;
  };

  time.timeZone = "Europe/Oslo";

  users.users.henrik = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    cloud-utils
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "25.11";
}
