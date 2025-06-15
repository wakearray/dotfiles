{ lib, config, pkgs, ... }:
let
  abs = config.servers.audiobookshelf;
  domain = abs.domain;
in
{
  # AudioBookShelf
  # https://www.audiobookshelf.org/docs

  options.servers.audiobookshelf = with lib; {
    enable = mkEnableOption "Enable opinionated AudioBookShelf install.";

    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "Domain name of the server. If using the default domain, AudioBookShelf will be accessible at `audiobookshelf.example.com`";
    };

    localPort = mkOption {
      type = types.port;
      default = 8066;
      description = "The local port where AudioBookShelf can be accessed.";
    };
  };

  config = lib.mkIf abs.enable {
    services.audiobookshelf = {
      enable = true;
      port = abs.port;
      package = pkgs.audiobookshelf;
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "audiobookshelf.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${builtins.toString abs.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
