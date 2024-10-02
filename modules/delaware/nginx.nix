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
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/${domain}";
      };
      "lobe.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:3210";
          };
        };
      };
      "cloud.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "audiobookshelf.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8066";
            proxyWebsockets = true;
          };
        };
      };
      "git.${domain}" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations = {
          "/" = {
            proxyPass = "http://localhost:8065";
          };
        };
      };
      "rss.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8064";
          };
        };
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
