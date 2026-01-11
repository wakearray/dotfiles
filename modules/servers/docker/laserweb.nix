{ lib, config, ... }:
let
  cfg = config.servers.docker.laserweb;
in
{
  options.servers.docker.laserweb = with lib; {
    enable = mkEnableOption "Enable an opinionated laserweb config.";

    domain = mkOption {
      type = types.str;
      default = "laser.example.com";
      description = "The domain you want laserweb hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 9001;
      description = "The local port you want laserweb hosted at.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.laserweb = {
      image = "joesantos/laserweb:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${builtins.toString cfg.localPort}:8000" ];
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.localPort}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}

