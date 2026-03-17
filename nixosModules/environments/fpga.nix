{ config, lib, pkgs, ... }:

let
  cfg = config.services.environments.fpga;
in
{
  options.services.environments.fpga = {
    enable = lib.mkEnableOption "FPGA development environment using open source tools";

    families = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [ "ice40" "ecp5" "gowin" "machxo2" ]);
      default = [ "ice40" ];
      description = "FPGA families to support. Determines which nextpnr backends and bitstream tools are installed.";
      example = [ "ice40" "ecp5" ];
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to include in the development environment";
      example = lib.literalExpression "[ pkgs.fujprog ]";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      let
        hasFamily = f: builtins.elem f cfg.families;
      in
      [
        # Synthesis (shared across all families)
        yosys

        # Place and route
        nextpnr

        # Simulation
        gtkwave
        verilator

        # USB programming (shared)
        dfu-util
      ]
      ++ lib.optionals (hasFamily "ice40") [
        icestorm       # icepack, iceprog, icetime
        icesprog
      ]
      ++ lib.optionals (hasFamily "ecp5") [
        trellis        # ecppack, ecpprog
        openFPGALoader
      ]
      ++ lib.optionals (hasFamily "gowin") [
        apicula        # gowin bitstream tools
        openFPGALoader
      ]
      ++ lib.optionals (hasFamily "machxo2") [
        trellis
        openFPGALoader
      ]
      ++ cfg.extraPackages;

    services.udev.extraRules =
      let
        ftdiRules = ''
          # FTDI programmers (common across many FPGA boards)
          ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666", GROUP="plugdev"
          ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666", GROUP="plugdev"
        '';

        ice40Rules = ''
          # iCEBreaker (1BitSquared)
          ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6146", MODE="0666", GROUP="plugdev"
        '';

        gowinRules = ''
          # Gowin USB programmer
          ATTRS{idVendor}=="20b7", ATTRS{idProduct}=="0001", MODE="0666", GROUP="plugdev"
        '';

        hasFamily = f: builtins.elem f cfg.families;
      in
      ftdiRules
      + lib.optionalString (hasFamily "ice40") ice40Rules
      + lib.optionalString (hasFamily "gowin") gowinRules;
  };
}
