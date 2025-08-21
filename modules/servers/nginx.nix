{ lib, config, ... }:
let
  cfg = config.servers.nginx;
in
{
  options.servers.nginx = with lib; {
    enable = mkEnableOption "Enable nginx";

    rootURL = {
      enable = mkEnableOption "Enable the root URL. If disabled, this server will enable nginx, but it won't have any virtualHosts by default.";

      domain = mkOption {
        type = types.str;
        default = "example.com";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Nginx reverse proxy
    services = {
      nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedTlsSettings = true;
        recommendedProxySettings = true;

        defaultListen = [
          { addr = "127.0.0.1"; port = 8443; ssl = true; }
        ];

        virtualHosts = {
          # Additional virtualHosts can be found with their respective services config files.
          "${cfg.domain}" = {
            enableACME = true;
            forceSSL = true;
            root = "/var/www/${cfg.domain}";
          };
        };
      };
      sslh = {
        enable = true;
        method = "select";
        port = 443;
        settings = {
          transparent = true;
          protocols = [
            {
              host = "localhost";
              name = "ssh";
              port = "22";
              service = "ssh";
            }
            {
              host = "localhost";
              name = "openvpn";
              port = "1194";
            }
            {
              host = "localhost";
              name = "xmpp";
              port = "5222";
            }
            {
              host = "localhost";
              name = "http";
              port = "80";
            }
            {
              host = "localhost";
              name = "tls";
              port = "8443";
            }
            {
              host = "localhost";
              name = "anyprot";
              port = "8443";
            }
          ];
        };
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "kent.hambrock@gmail.com";
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
