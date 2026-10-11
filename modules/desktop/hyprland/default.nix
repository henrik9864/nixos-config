{ inputs, ... }: {
  flake.modules.nixos.hyprland =
    { config, pkgs, pkgs-unstable ? pkgs, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      hardware.nvidia = {
        open = true;
        modesetting.enable = true;
        nvidiaSettings = true;
        package = (pkgs-unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.latest;
        powerManagement.enable = true;
      };
      hardware.graphics.enable = true;

      services.getty.autologinUser = "henrik";

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      };

      home-manager.users.henrik = { pkgs, ... }: {
        imports = [
          ./_home/settings.nix
          ./_home/binds.nix
          ./_home/hw.nix
          ./_home/scratchpad.nix
          ./_home/dev-windows.nix
        ];

        wayland.windowManager.hyprland.enable = true;

        services.udiskie = {
          enable = true;
          automount = true;
          notify = true;
          tray = "auto";
        };

        # tools the keybinds call
        home.packages = with pkgs; [
          nemo
          grim
          slurp
          wl-clipboard
          playerctl
          pamixer
          brightnessctl
          libnotify
        ];
      };
    };
}
