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
  };

  config = lib.mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        dataDir = cfg.dataDir;
        consumptionDir = cfg.consumptionDir;
      };
      vsftpd = {
        enable = true;
        anonymousUser = true;
        writeEnable = true;
        anonymousUserHome = cfg.consumptionDir;
      };
    };
  };
}
