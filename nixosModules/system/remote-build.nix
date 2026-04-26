{ config, lib, ... }:

let
  cfg = config.system.remoteBuild;
in
{
  options.system.remoteBuild = {
    enable = lib.mkEnableOption "use a remote machine as a Nix build machine";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "192.168.10.62";
      description = "Hostname or IP of the remote build machine";
      example = "192.168.10.62";
    };

    hostPublicKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the remote build machine's SSH host public key (from ssh-keyscan). Used to populate root's known_hosts declaratively.";
      example = "../../keys/nix-cache-host.pub";
    };

    sshUser = lib.mkOption {
      type = lib.types.str;
      default = "henrik";
      description = "SSH user to connect as on the remote build machine";
    };

    maxJobs = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Maximum number of parallel build jobs on the remote machine";
    };

    speedFactor = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = "Relative speed factor of the remote machine (higher = preferred more)";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.distributedBuilds = true;

    nix.buildMachines = [
      {
        hostName = cfg.hostName;
        system = "x86_64-linux";
        protocol = "ssh";
        sshUser = cfg.sshUser;
        sshKey = "/root/.ssh/nix-build";
        maxJobs = cfg.maxJobs;
        speedFactor = cfg.speedFactor;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];

    # Declaratively add the remote build host to root's known_hosts
    programs.ssh.knownHosts = lib.mkIf (cfg.hostPublicKeyFile != null) {
      "${cfg.hostName}".publicKey = lib.strings.trim (builtins.readFile cfg.hostPublicKeyFile);
    };

    # Fall back to local builds if the remote is unavailable
    nix.extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}

