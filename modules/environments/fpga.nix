{ ... }:
{
  flake.modules.nixos.fpga = { config, lib, pkgs, ... }: let
    cfg = config.services.environments.fpga;
    hasFamily = f: builtins.elem f cfg.families;
  in {
    options.services.environments.fpga = {
      enable = lib.mkEnableOption "FPGA development environment using open source tools";
      families = lib.mkOption {
        type = lib.types.listOf (lib.types.enum [ "ice40" "ecp5" "gowin" "machxo2" ]);
        default = [ "ice40" ];
        description = "FPGA families to support.";
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
      environment.systemPackages =
        with pkgs;
        [ yosys nextpnr gtkwave verilator dfu-util ]
        ++ lib.optionals (hasFamily "ice40") [ icestorm icesprog ]
        ++ lib.optionals (hasFamily "ecp5") [ trellis openFPGALoader ]
        ++ lib.optionals (hasFamily "gowin") [ apicula openFPGALoader ]
        ++ lib.optionals (hasFamily "machxo2") [ trellis openFPGALoader ]
        ++ cfg.extraPackages;
      services.udev.extraRules =
        let
          ftdiRules = ''
            ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666", GROUP="plugdev"
            ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666", GROUP="plugdev"
          '';
          ice40Rules = ''
            ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6146", MODE="0666", GROUP="plugdev"
          '';
          gowinRules = ''
            ATTRS{idVendor}=="20b7", ATTRS{idProduct}=="0001", MODE="0666", GROUP="plugdev"
          '';
        in
        ftdiRules
        + lib.optionalString (hasFamily "ice40") ice40Rules
        + lib.optionalString (hasFamily "gowin") gowinRules;
    };
  };
}
