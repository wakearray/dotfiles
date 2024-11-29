{ lib, config, ... }:
{
  options.servers.tt-rss = {
    enable = lib.mkEnableOption "tt-rss";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8064;
      description = "The localhost port to use.";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "rss.localhost";
      description = "The nginx domain you'll be accessing the site from.";
    };

    selfUrlPath = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost";
      description = "The URL where the server can be found.";
    };
  };
  config = lib.mkIf config.servers.tt-rss.enable {
    services = {
      tt-rss = {
        enable = true;
        selfUrlPath = "${config.servers.tt-rss.selfUrlPath}:${config.servers.tt-rss.port}";
      };

      servers.nginx.enable = true;
      # Nginx reverse proxy
      nginx.virtualHosts = {
        "${config.servers.tt-rss.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "${config.servers.tt-rss.selfUrlPath}:${config.servers.tt-rss.port}";
            };
          };
        };
      };
    };
  };
}
