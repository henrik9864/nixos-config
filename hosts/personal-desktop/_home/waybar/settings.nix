{ ... }:
let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "14px";
    font_weight = "bold";
    text_color = "#FBF1C7";
    background_0 = "#1D2021";
    background_1 = "#282828";
    border_color = "#928374";
    red = "#CC241D";
    green = "#98971A";
    yellow = "#FABD2F";
    blue = "#458588";
    magenta = "#B16286";
    cyan = "#689D6A";
    orange = "#D65D0E";
    opacity = "1";
  };
in
{
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
    modules-center = [ "clock" ];
    modules-right = [
      "custom/proxmox"
      "custom/spacer"
      "cpu"
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
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
        "5" = [ ];
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
      format-icons.default = [ "󰕾" ];
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
  };
}
