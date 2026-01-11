{ lib, config, ... }:
let
  cfg = config.servers.docker.vaultwarden;
in
{
  options.servers.docker.vaultwarden = with lib; {
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

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be a complete environment file named `vaultwardenEnvironmentVars` including (but not limited to) `PUSH_INSTALLATION_ID`, `PUSH_INSTALLATION_KEY`, and `ADMIN_TOKEN`.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.vaultwarden = {
      image = "vaultwarden/server:latest";
      autoStart = true;
      environmentFiles = [
        config.sops.templates."vaultwardenEnvironmentFile.env".path
      ];
      #environment = {
      #  ADMIN_TOKEN="\${VAULTWARDEN_ADMIN_TOKEN}";
      #};
      volumes = [
        "${cfg.dataFolder}:/data/"
      ];
      ports = let port = builtins.toString cfg.localPort; in [
        "127.0.0.1:${port}:${port}"
      ];
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

    # sops secrets
    sops.secrets = {
      vw_push_id = { sopsFile = cfg.sopsFile; };
      vw_push_key = { sopsFile = cfg.sopsFile; };
      vw_admin_token = { sopsFile = cfg.sopsFile; };
    };

    sops.templates."vaultwardenEnvironmentFile.env" = {
      content  = ''
        PUSH_ENABLED=true
        PUSH_INSTALLATION_ID=${config.sops.placeholder.vw_push_id}
        PUSH_INSTALLATION_KEY=${config.sops.placeholder.vw_push_key}
        ADMIN_TOKEN=${config.sops.placeholder.vw_admin_token}

        DOMAIN=https://${cfg.domain}
        SIGNUPS_ALLOWED=false
        ROCKET_PORT=${builtins.toString cfg.localPort}
        ROCKET_LOG=critical
      '';
    };
  };
}
