{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.environments.cpp;
in
{
  options.services.environments.cpp = {
    enable = lib.mkEnableOption "C++ development environment with CMake";

    compiler = lib.mkOption {
      type = lib.types.enum [
        "gcc"
        "clang"
      ];
      default = "gcc";
      description = "The C++ compiler toolchain to use";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to include in the development environment";
      example = lib.literalExpression "[ pkgs.boost pkgs.eigen ]";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      let
        compilerPkg = if cfg.compiler == "gcc" then [ gcc ] else [ clang ];
      in
      compilerPkg
      ++ [
        # Build system
        cmake
        ccache
        gnumake
        ninja
        pkg-config

        # Core build tools
        binutils
        autoconf
        automake
        libtool

        # Formatting
        clang-tools

        # Debugger
        gdb

        # Testing
        gtest
      ]
      ++ cfg.extraPackages;
  };
}
