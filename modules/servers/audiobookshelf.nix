{ lib, config, pkgs, ... }:
let
  abs = config.servers.audiobookshelf;
in
{
  # AudioBookShelf
  # https://www.audiobookshelf.org/docs

  options.servers.audiobookshelf = with lib; {
    enable = mkEnableOption "Enable opinionated AudioBookShelf install.";

    domain = mkOption {
      type = types.str;
      default = "audiobookshelf.example.com";
      description = "Domain name of the server.";
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
      port = abs.localPort;
      package = pkgs.audiobookshelf;
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${abs.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${builtins.toString abs.localPort}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
