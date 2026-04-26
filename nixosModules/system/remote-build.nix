{ config, lib, ... }:

let
  cfg = config.system.remoteBuild;
in
{
  options.system.remoteBuild = {
    enable = lib.mkEnableOption "use a remote machine as a Nix build machine";

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Hostname or IP of the remote build machine";
      example = "192.168.10.62";
    };

    hostPublicKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the remote build machine's SSH host public key. Used to populate known_hosts declaratively.";
      example = "../../keys/nix-cache-host.pub";
    };

    sshUser = lib.mkOption {
      type = lib.types.str;
      description = "SSH user on the remote build machine. Must be in trusted-users on the remote.";
      example = "henrik";
    };

    sshKey = lib.mkOption {
      type = lib.types.str;
      description = "Path to the SSH private key used for remote builds.";
      example = "/home/henrik/.ssh/nix-build";
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
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = [
      {
        hostName = cfg.hostName;
        system = "x86_64-linux";
        # ssh-ng requires sshUser to be a trusted-user on the remote
        protocol = "ssh-ng";
        sshUser = cfg.sshUser;
        sshKey = cfg.sshKey;
        maxJobs = cfg.maxJobs;
        speedFactor = cfg.speedFactor;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];

    programs.ssh.knownHosts = lib.mkIf (cfg.hostPublicKeyFile != null) {
      "${cfg.hostName}".publicKey = lib.strings.trim (builtins.readFile cfg.hostPublicKeyFile);
    };
  };
}

