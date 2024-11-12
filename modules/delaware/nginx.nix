{ domain, ... }:
{
  # Nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      # Additional virtualHosts can be found with their respective services config files.
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/${domain}";
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "kent.hambrock@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
