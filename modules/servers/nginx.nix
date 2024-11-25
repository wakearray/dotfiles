{ lib, config, ... }:
{
  options.servers.nginx = {
    enable = lib.mkEnableOption "Nginx" ;

    domain = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
    };
  };

  config = lib.mkIf config.servers.nginx.enable {
    # Nginx reverse proxy
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        # Additional virtualHosts can be found with their respective services config files.
        "${config.servers.nginx.domain}" = {
          enableACME = true;
          forceSSL = true;
          root = "/var/www/${config.servers.nginx.domain}";
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
