{ config, lib, ... }:
let
  cfg = config.servers.rss;
in
{
  options.servers.rss = with lib; {
    enable = mkEnableOption "Enable an opinionated Miniflux config.";

    domain = mkOption {
      type = types.str;
      default = "rss.example.com";
      description = "Domain of the nginx proxy hosting this server.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `minifluxCredentialsEnvironmentVars` representing the entire miniflux environment variables file.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = !(builtins.isNull cfg.sopsFile);
      message = "Please define a sops file with admin credentials."; }];
    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.templates."minifluxCredentialsEnvironmentFile".path;
    };

    sops.secrets.minifluxCredentialsEnvironmentVars = {
      sopsFile = cfg.sopsFile;
    };

    sops.templates."minifluxCredentialsEnvironmentFile" = {
      content = ''
        ${config.sops.placeholder.minifluxCredentialsEnvironmentVars}
      '';
    };
  };
}
