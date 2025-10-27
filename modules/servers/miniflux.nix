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

    localPort = mkOption {
      type = types.port;
      default = 8080;
      description = "The port you want to use when locally accessing the server on the same network.";
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
      config = {
        LISTEN_ADDR = "127.0.0.1:${builtins.toString cfg.localPort}";
      };
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${builtins.toString cfg.localPort}";
          };
        };
      };
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
