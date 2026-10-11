{inputs, ...}: {
  flake.modules.nixos.noctalia = {
    hardware.bluetooth.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    home-manager.users.henrik = {
      imports = [inputs.noctalia.homeModules.default];
      systemd.user.services.noctalia.Service.KillMode = "process";
      systemd.user.services.noctalia.Service.Environment = "LD_LIBRARY_PATH=/run/opengl-driver/lib";
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          shell = {
            font_family = "JetBrainsMono Nerd Font";
            corner_radius_scale = 1.5;
            polkit_agent = true;
          };

          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
            templates = {
              enable_builtin_templates = true;
              enable_community_templates = true;
              builtin_ids = ["btop"];
              community_ids = [];
            };
          };

          widget = {
            clock = {
              format = "{:%d/%m/%Y - %H:%M:%S}";
              tooltip_format = "{:%A, %B %d, %Y}";
            };
            gpu = {
              type = "sysmon";
              stat = "gpu_usage";
            };
            gpu_vram = {
              type = "sysmon";
              stat = "gpu_vram";
            };
            storage = {
              type = "sysmon";
              stat = "disk_pct";
            };
          };

          bar.main = {
            position = "bottom";
            thickness = 38;
            radius = 16;
            margin_ends = 40;
            background_opacity = 0.85;
            capsule = true;
            shadow = true;
            start = [
              "launcher"
              "wallpaper"
              "workspaces"
              "nix-monitor"
            ];
            center = [
              "clock"
              "weather"
            ];
            end = [
              "tray"
              "notifications"
              "group:network_group"
              "volume"
              "brightness"
              "cpu"
              "group:gpu_group"
              "ram"
              "storage"
              "session"
            ];
            capsule_group = [
              {
                id = "network_group";
                members = ["network_rx" "network_tx"];
              }
              {
                id = "gpu_group";
                members = ["gpu" "gpu_vram"];
              }
            ];
          };

          wallpaper.default.path = "/home/henrik/walls/otherWallpaper/space_kurz/space_earth.jpg";

          weather = {
            enabled = true;
            unit = "celsius";
            refresh_minutes = 30;
          };

          location.auto_locate = true;
          nightlight.enabled = true;
          system.monitor = {
            enabled = true;
            gpu_poll_seconds = 2;
          };
        };
      };
    };
  };
}
