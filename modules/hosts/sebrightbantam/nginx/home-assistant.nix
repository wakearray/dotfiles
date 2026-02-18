{ config, ... }:
let
  domain = ".home.arpa";
in
{
  config = {
    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "home-assistant.${domain}" = {
        kTLS = true;
        forceSSL = true;
        # TODO: Add keys
        sslTrustedCertificate = config.sops.templates."home-assistant-ca-bundle.cert".path;
        sslCertificateKey = config.sops.templates."home-assistant-ssl-key.key".path;
        sslCertificate = config.sops.templates."home-assistant-ssl-cert.cert".path;
        locations = {
          "/" = {
            proxyPass = "http://192.168.0.138:8123";
            proxyWebsockets = true;
          };
        };
      };
    };

    sops.secrets = let
      opts = {
        sopsFile = ./home-assistant.yaml;
      };
    in
    {
      home-assistant-ca-bundle = opts;
      home-assistant-ssl-key = opts;
      home-assistant-ssl-cert = opts;
    };

    sops.templates = {
      "home-assistant-ca-bundle.cert" = {
        content = ''
          ${config.sops.placeholder.home-assistant-ca-bundle}
        '';
      };
      "home-assistant-ssl-key.key" = {
        content = ''
          ${config.sops.placeholder.home-assistant-ssl-key}
        '';
      };
      "home-assistant-ssl-cert.cert" = {
        content = ''
          ${config.sops.placeholder.home-assistant-ssl-cert}
        '';
      };
    };
  };
}
