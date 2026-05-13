{...}: let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "14px";
    font_weight = "bold";
    text_color = "#E0E8F0";
    background_0 = "#0F202E";
    background_1 = "#1A3A52";
    border_color = "#5A7D9A";
    red = "#E06C75";
    green = "#96BB94";
    yellow = "#E6C679";
    blue = "#7FBBE5";
    magenta = "#9981D3";
    cyan = "#66C3C8";
    orange = "#EB9F85";
    opacity = "1";
  };
in {
  programs.waybar.settings.mainBar = with custom; {
    position = "bottom";
    layer = "top";
    height = 28;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "hyprland/workspaces"
      "tray"
    ];
    modules-center = ["clock"];
    modules-right = [
      "custom/proxmox"
      "custom/ssh"
      "custom/spacer"
      "cpu"
      "custom/gpu"
      "memory"
      "disk"
      "pulseaudio"
      "network"
      "hyprland/language"
      "custom/notification"
      "custom/power-menu"
    ];
    clock = {
      format = "{:%d/%m/%Y - %H:%M:%S}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      interval = 1;
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "I";
        "2" = "II";
        "3" = "III";
        "4" = "IV";
        "5" = "V";
        "6" = "VI";
        "7" = "VII";
        "8" = "VIII";
        "9" = "IX";
        "10" = "X";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [];
        "2" = [];
        "3" = [];
      };
    };
    "hyprland/language" = {
      format = "󰌌 {short}";
      keyboard-name = "lvt-titan-m-pro-gaming-mouse-keyboard";
    };
    cpu = {
      format = "<span foreground='${green}'>󰻠 </span>{usage}%";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --title float_kitty btop'";
    };
    memory = {
      format = "<span foreground='${cyan}'>󰟜 </span>{}%";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --title float_kitty btop'";
    };
    disk = {
      format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
      interval = 60;
    };
    network = {
      format-wifi = "<span foreground='${magenta}'>󰤨 </span> {signalStrength}%";
      format-ethernet = "<span foreground='${magenta}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-disconnected = "<span foreground='${magenta}'>󰤭 </span>";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "<span foreground='${blue}'>{icon}</span> {volume}%";
      format-muted = "<span foreground='${blue}'> </span> {volume}%";
      format-icons.default = ["󰕾"];
      scroll-step = 2;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };
    "custom/proxmox" = {
      format = "󰒋 {}";
      interval = 30;
      exec = "waybar-proxmox";
      return-type = "json";
      on-click = "xdg-open https://192.168.10.24:8006";
    };
    "custom/ssh" = {
      format = "{}";
      interval = 1;
      exec = "waybar-ssh";
      return-type = "json";
      on-click = "waybar-ssh click";
      on-scroll-up = "waybar-ssh scroll-up; pkill -RTMIN+1 waybar";
      on-scroll-down = "waybar-ssh scroll-down; pkill -RTMIN+1 waybar";
      signal = 1;
      tooltip = false;
    };
    "custom/spacer" = {
      format = " ";
      tooltip = false;
    };
    "custom/notification" = {
      tooltip = true;
      format = "{icon}";
      format-icons = {
        "none" = "<span foreground='${blue}'>󰂚</span>";
        "notification" = "<span foreground='${red}'>󰂞</span>";
        "dnd-none" = "<span foreground='${blue}'>󰂛</span>";
        "dnd-notification" = "<span foreground='${red}'>󰂞</span>";
        "inhibited-none" = "<span foreground='${blue}'>󰂚</span>";
        "inhibited-notification" = "<span foreground='${red}'>󰂞</span>";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
    "custom/power-menu" = {
      tooltip = true;
      tooltip-format = "Power menu";
      format = "<span foreground='${red}'>󰐥 </span>";
      on-click = "wlogout";
    };

    "custom/gpu" = {
      format = "<span foreground='${yellow}'>󰍛 </span>{}";
      interval = 2;
      tooltip = false;
      return-type = "json";

      exec = ''
        nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits |
        awk '{ printf("{\"text\":\"%s%% \"}\n", $1) }'
      '';
    };
  };
}
