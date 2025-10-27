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

        virtualHosts = lib.mkIf cfg.rootURL.enable {
          # Additional virtualHosts can be found with their respective services config files.
          "${cfg.rootURL.domain}" = {
            enableACME = true;
            forceSSL = true;
            root = "/var/www/${cfg.rootURL.domain}";
          };
        };
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "kent.hambrock@gmail.com";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
