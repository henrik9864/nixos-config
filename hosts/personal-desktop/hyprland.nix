{
  config,
  pkgs,
  inputs,
  ...
}:
let
  waybar-proxmox = pkgs.writeShellScriptBin "waybar-proxmox" ''
    token=$(cat "$HOME/.secrets/proxmox-token" 2>/dev/null) || exit 1

    resources=$(${pkgs.curl}/bin/curl -sf \
      --insecure \
      -H "Authorization: PVEAPIToken=$token" \
      "https://192.168.10.24:8006/api2/json/cluster/resources?type=vm") || exit 1

    total=$(echo "$resources" | ${pkgs.jq}/bin/jq '[.data[] | select(.type == "qemu" or .type == "lxc")] | length')
    running=$(echo "$resources" | ${pkgs.jq}/bin/jq '[.data[] | select((.type == "qemu" or .type == "lxc") and .status == "running")] | length')

    echo "{\"text\": \"$running/$total\", \"tooltip\": \"$running running out of $total VMs/CTs\"}"
  '';
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.graphics.enable = true;

  services.getty.autologinUser = "henrik";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
  };

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    hyprpaper
    hypridle
    hyprlock
    rofi
    dunst
    libnotify
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
    kdePackages.dolphin
    polkit_gnome
    btop
    fastfetch
    waybar-proxmox
  ];
}
