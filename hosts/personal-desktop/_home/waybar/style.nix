{ ... }:
let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "14px";
    font_weight = "bold";
    text_color = "#FBF1C7";
    background_0 = "#1D2021";
    background_1 = "#282828";
    border_color = "#A89984";
    red = "#CC241D";
    green = "#98971A";
    yellow = "#FABD2F";
    blue = "#458588";
    magenta = "#B16286";
    cyan = "#689D6A";
    orange = "#D65D0E";
    orange_bright = "#FE8019";
    opacity = "1";
  };
in
{
  programs.waybar.style = with custom; ''
    * {
      border: none;
      border-radius: 0px;
      padding: 0;
      margin: 0;
      font-family: ${font};
      font-weight: ${font_weight};
      opacity: ${opacity};
      font-size: ${font_size};
    }
    window#waybar {
      background: ${background_1};
      border-top: 1px solid ${border_color};
    }
    tooltip {
      background: ${background_1};
      border: 1px solid ${border_color};
    }
    tooltip label {
      margin: 5px;
      color: ${text_color};
    }
    #workspaces { padding-left: 15px; }
    #workspaces button {
      color: ${yellow};
      padding-left: 5px;
      padding-right: 5px;
      margin-right: 10px;
    }
    #workspaces button.empty { color: ${text_color}; }
    #workspaces button.active { color: ${orange_bright}; }
    #clock { color: ${text_color}; }
    #tray {
      margin-left: 10px;
      color: ${text_color};
    }
    #tray menu {
      background: ${background_1};
      border: 1px solid ${border_color};
      padding: 8px;
    }
    #pulseaudio, #network, #cpu, #memory, #disk,
    #custom-notification, #custom-power-menu, #custom-proxmox,
    #custom-ssh, #language {
      padding-left: 5px;
      padding-right: 5px;
      margin-right: 10px;
      color: ${text_color};
    }
    #pulseaudio, #custom-notification {
      margin-left: 15px;
    }
    #custom-spacer {
      margin-right: 260px;
    }
    #custom-ssh {
      color: ${cyan};
      min-width: 84px;
      padding-left: 5px;
    }
    #custom-power-menu {
      padding-right: 2px;
      margin-right: 5px;
    }
  '';
}
