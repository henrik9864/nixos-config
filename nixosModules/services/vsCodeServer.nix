{ config, lib, ... }:
{
  imports = [
    (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "sha256-036hiwp79v48v1arcxnjzirxzrw1il2c1rxihysykz9yv06mfplf=";
    })
  ];
}
