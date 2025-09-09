{ config, lib, ... }:
let
  cfg = config.servers.mattermost;
in
{
  options.servers.mattermost = with lib; {
    enable = mkEnableOption "Enable an opinionated Mattermost config.";

    domain = mkOption {
      type = types.str;
      default = "chat.example.com";
      description = "Subdomain and domain of the hosted instance.";
    };

    localPort = mkOption {
      type = types.port;
      default = 8065;
      description = "Port of the webserver.";
    };

    siteName = mkOption {
      type = types.str;
      default = "Mattermost";
      description = "Name of the website hosting this instance.";
    };

  };

  config = lib.mkIf cfg.enable {
    services = {
      mattermost = {
        enable = true;
        siteName = cfg.siteName;
        siteUrl = "https://${cfg.domain}";
        port = cfg.localPort;
        mutableConfig = true;
        #environmentFile = ""; # TODO:
      };

      # Nginx reverse proxy
      nginx.virtualHosts = {
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${builtins.toString cfg.localPort}";
              proxyWebsockets = true;
            };
          };
        };
      };

    };
  };
}
