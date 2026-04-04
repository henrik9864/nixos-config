{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.environments.dotnet;

  combinedSdk = pkgs.dotnetCorePackages.combinePackages cfg.sdks;
in
{
  options.services.environments.dotnet = {
    enable = lib.mkEnableOption ".NET development environment";

    sdks = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.dotnet-sdk_9 ];
      description = "List of .NET SDK packages to install";
      example = lib.literalExpression "[ pkgs.dotnet-sdk_8 pkgs.dotnet-sdk_9 ]";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to include in the development environment";
      example = lib.literalExpression "[ pkgs.azure-cli ]";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      combinedSdk

      # Tools
      pkgs.omnisharp-roslyn
      pkgs.nuget-to-json
    ]
    ++ cfg.extraPackages;

    environment.sessionVariables = {
      DOTNET_ROOT = "${combinedSdk}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    };
  };
}
