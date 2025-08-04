{ lib, config, ... }:
let
  cfg = config.servers.vaultwarden;
in
{
  options.servers.vaultwarden = with lib; {
    enable = mkEnableOption "Enable an opinionated vaultwarden config.";

    domain = mkOption {
      type = types.str;
      default = "vault.example.com";
      description = "The domain you want vaultwarden hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 8222;
      description = "The local port you want vaultwarden hosted at.";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "/var/lib/vaultwarden/";
      description = "String of path to where you want the vault to be located.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        DATA_FOLDER = cfg.dataFolder;
        PUSH_ENABLED = false;
        # PUSH_INSTALLATION_ID=CHANGEME
        # PUSH_INSTALLATION_KEY=CHANGEME
        DOMAIN = "https://${cfg.domain}";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.localPort;
        ROCKET_LOG = "critical";

      };
    };
    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.localPort}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
