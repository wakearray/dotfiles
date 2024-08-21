{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
  domain = "voicelesscrimson.com";
in
{
  # Nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "${config.domain}" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/${config.domain}";
      };
      "lobe.${config.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:3210";
          };
        };
      };
      "cloud.${config.domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "audiobookshelf.${config.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8066";
            proxyWebsockets = true;
          };
        };
      };
      "git.${config.domain}" = {
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
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "kent.hambrock@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

}
