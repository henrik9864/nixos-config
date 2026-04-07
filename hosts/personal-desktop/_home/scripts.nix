{ pkgs, ... }:
let
  hosts = [
    {
      name = "proxmox";
      user = "root";
      ip = "192.168.10.24";
    }
    {
      name = "docker";
      user = "henrik";
      ip = "192.168.10.61";
    }
    {
      name = "dev";
      user = "henrik";
      ip = "192.168.10.60";
    }
  ];

  hostCount = builtins.length hosts;
  hostNames = builtins.concatStringsSep " " (map (h: "\"${h.name}\"") hosts);
  hostTargets = builtins.concatStringsSep " " (map (h: "\"${h.user}@${h.ip}\"") hosts);

  waybar-proxmox = pkgs.writeShellApplication {
    name = "waybar-proxmox";
    runtimeInputs = [
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      token=$(cat ~/.secrets/proxmox-token)
      resources=$(curl -sf --insecure \
        -H "Authorization: PVEAPIToken=$token" \
        "https://192.168.10.24:8006/api2/json/cluster/resources")

      total=$(echo "$resources" | jq '[.data[] | select(.type == "qemu" or .type == "lxc")] | length')
      running=$(echo "$resources" | jq '[.data[] | select((.type == "qemu" or .type == "lxc") and .status == "running")] | length')

      echo "$resources" | jq -c \
        --argjson running "$running" \
        --argjson total "$total" \
        '{
          text: "\($running)/\($total)",
          tooltip: ([.data[] | select(.type == "qemu" or .type == "lxc")] | map("\(.name): \(.status)") | join("\n"))
        }'
    '';
  };

  waybar-ssh = pkgs.writeShellApplication {
    name = "waybar-ssh";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/waybar-ssh-index"

      NAMES=(${hostNames})
      TARGETS=(${hostTargets})
      COUNT=${toString hostCount}

      if [ -f "$STATE_FILE" ]; then
        INDEX=$(cat "$STATE_FILE")
      else
        INDEX=0
        echo "$INDEX" > "$STATE_FILE"
      fi

      if [ "$INDEX" -lt 0 ]; then INDEX=0; fi
      if [ "$INDEX" -ge "$COUNT" ]; then INDEX=$((COUNT - 1)); fi

      case "''${1:-}" in
        scroll-up)
          INDEX=$(( (INDEX - 1 + COUNT) % COUNT ))
          echo "$INDEX" > "$STATE_FILE"
          ;;
        scroll-down)
          INDEX=$(( (INDEX + 1) % COUNT ))
          echo "$INDEX" > "$STATE_FILE"
          ;;
        click)
          TARGET="''${TARGETS[$INDEX]}"
          kitty --title float_kitty ssh -o "SetEnv TERM=xterm-256color" "$TARGET" &
          disown
          exit 0
          ;;
      esac

      NAME=$(printf "%-10s" "''${NAMES[$INDEX]}")

      LINES="[]"
      for i in "''${!NAMES[@]}"; do
        if [ "$i" -eq "$INDEX" ]; then
          LINE="> ''${NAMES[$i]}"
        else
          LINE="  ''${NAMES[$i]}"
        fi
        LINES=$(echo "$LINES" | jq -c --arg l "$LINE" '. + [$l]')
      done

      jq -cn \
        --arg text "󰣀 $NAME" \
        --argjson lines "$LINES" \
        '{text: $text, tooltip: ($lines | join("\n"))}'
    '';
  };
in
{
  home.packages = [
    waybar-proxmox
    waybar-ssh
  ];
}
