{ lib, config, ... }:
{
  options.servers.tt-rss = {
    enable = lib.mkEnableOption "tt-rss";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "rss.example.com";
      description = "The nginx domain you'll be accessing the site from.";
    };
  };
  config = lib.mkIf config.servers.tt-rss.enable {
    services = {
      tt-rss = {
        enable = true;
        virtualHost = "${config.servers.tt-rss.domain}";
      };

      # Nginx reverse proxy
      nginx.virtualHosts."${config.servers.tt-rss.domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
    servers.nginx.enable = true;
  };
}
