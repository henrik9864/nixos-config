{inputs, ...}: {
  flake.modules.nixos.base = {
    imports = [inputs.nix-index-database.nixosModules.nix-index];

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.trusted-users = ["@wheel"];

    programs.nix-index-database.comma.enable = true;

    environment.enableAllTerminfo = true;
  };
}
