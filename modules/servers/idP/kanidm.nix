{ config, lib, pkgs, ... }:
let
  cfg = config.servers.kanidm;
in
{
  options.servers.kanidm = with lib; {
    enable = mkEnableOption "Enable an opinionated Kanidm config.";

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "Domain used for the kanidm server.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "idm";
      description = "The subdomain that Kanidm will be hosted at.";
    };

    ldapPort = mkOption {
      type = types.port;
      description = "The port on which to have the LDAP server.";
      default = 636;
    };

    httpPort = mkOption {
      type = types.port;
      description = "The port on which to have the HTTP server, for user login and administration.";
      default = 8443;
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanidm = {
      package = pkgs.kanidm_1_9;
      client = {
        enable = true;
        settings.uri = "https://${cfg.subdomain}.${cfg.domain}";
      };
      server = {
        enable = true;
        settings = {
          tls_key = "/var/lib/acme/${cfg.subdomain}.${cfg.domain}/key.pem";
          tls_chain = "/var/lib/acme/${cfg.subdomain}.${cfg.domain}/fullchain.pem";
          role = "WriteReplica";
          origin = "https://${cfg.subdomain}.${cfg.domain}";
          online_backup = {
            versions = 3;
            schedule = "00 22 * * *";
            path = "/var/lib/kanidm/backups";
          };
          log_level = "info";
          ldapbindaddress = "0.0.0.0:${toString cfg.ldapPort}";
          domain = "${cfg.subdomain}.${cfg.domain}";
          bindaddress = "127.0.0.1:${toString cfg.httpPort}";
        };
      };
    };

    # Add kanidm user to nginx group so it can read the certs
    users.users."kanidm".extraGroups = [ "nginx" ];

    # Nginx reverse proxy
    services.nginx.virtualHosts."${cfg.subdomain}.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "https://localhost:${toString cfg.httpPort}";
        proxyWebsockets = true;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
      cfg.ldapPort
    ];
  };
}
