{ lib, config, ... }:
let
  cfg = config.servers.paperless;
in
{
  options.servers.paperless = with lib; {
    enable = mkEnableOption "Enable an opinionated Paperless-ngx server.";

    localPort = mkOption {
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
      default = "example.com";
      description = "Domain you intend to access your paperless instance from.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "paperless";
      description = "The subdomain that your server will be hosted at.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        address = "0.0.0.0";
        dataDir = cfg.dataDir;
        consumptionDir = cfg.consumptionDir;
        domain = "${cfg.subdomain}.${cfg.domain}";
        database.createLocally = true;
      };

      # FTP server
      vsftpd = {
        enable = true;
        anonymousUser = true;
        writeEnable = true;
        anonymousUserHome = cfg.consumptionDir;
      };
    };

    networking.firewall.allowedTCPPorts = [ 20 21 ] ++ lib.optionals (!cfg.sameServerHost) [ cfg.localPort ];
  };
}
