{ lib, config, ... }:
let
  cfg = config.servers.paperless;
in
{
  options.servers.paperless = with lib; {
    enable = mkEnableOption "Enable an opinionated Paperless-ngx server.";

    port = mkOption {
      type = types.port;
      default = 28981;
      description = "Local paperless port.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/paperless";
      description = "Directory to store the Paperless data.";
    };

    consumptionDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/consume";
      description = "Directory from which new documents are imported.";
    };

    domain = mkOption {
      type = types.str;
      default = "paperless.example.com";
      description = "Domain you intend to access your paperless instance from.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        dataDir = cfg.dataDir;
        consumptionDir = cfg.consumptionDir;
        domain = cfg.domain;
      };

      # FTP server
      vsftpd = {
        enable = true;
        anonymousUser = true;
        writeEnable = true;
        anonymousUserHome = cfg.consumptionDir;
      };

      # Nginx server
      nginx.virtualHosts."${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString cfg.port}";
          };
        };
      };
    };
  };
}
