{ lib, config, ... }:
let
  cfg = config.servers.nginx.karakeep;
in
{
  options.servers.nginx.karakeep = with lib; {
    enable = mkEnableOption "Enable an nginx reverse proxy server.";

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "The domain your server will be hosted at.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "pin";
      description = "The subdomain that your server will be hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 3000;
      description = "The local port your server is exposed on.";
    };

    localIP = mkOption {
      type = types.str;
      default = "localhost";
      description = "The local network IP address of the server. Use `localhost` or `127.0.0.1` if server is running on the same host as the nginx reverse proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Nginx reverse proxy
    services.nginx.virtualHosts."${cfg.subdomain}.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${cfg.localIP}:${toString cfg.localPort}";
        proxyWebsockets = true;
      };
    };
  };
}
