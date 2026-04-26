{ lib, config, ... }:
let
  cfg = config.servers.docker.endurain;
in
{
  options.severs.docker.endurain = with lib; {
    enable = mkEnableOption "Enable an opinionated Endurain config.";

    sameServerHost = mkEnableOption "If false, localPort will be exposed, if true it won't be.";

    localPort = mkOption {
      type = types.port;
      default = 8080;
      description = "The local port you want endurain hosted at.";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "/var/lib/vaultwarden/";
      description = "String of path to where you want the data to be located.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      "endurain-postgres" = {
        image = "docker.io/postgres:17.5";
        environmentFiles = [];
        extraOptions = [
          "--env-file=/etc/endurain/.env"
          "--health-cmd=pg_isready -U endurain"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--network=endurain-network"
        ];
        volumes = [
          "/var/lib/endurain/postgres/data:/var/lib/postgresql/data"
        ];
      };

      "endurain-app" = {
        image = "ghcr.io/endurain-project/endurain:latest";
        environmentFiles = [];
        extraOptions = [ "--network=endurain-network" ];
        volumes = [
          # Optional live-code volume (uncomment if needed):
          # "/var/lib/endurain/backend/app:/app/backend"
          "/var/lib/endurain/backend/data:/app/backend/data"
          "/var/lib/endurain/backend/logs:/app/backend/logs"
        ];
        ports = [ "${toString cfg.localPort}:8080" ];
        dependsOn = [ "endurain-postgres" ];
      };
    };

    # WIP: Replace this!
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
        ROCKET_PORT=${toString cfg.localPort}
        ROCKET_LOG=critical

        EXPERIMENTAL_CLIENT_FEATURE_FLAGS=inline-menu-positioning-improvements,inline-menu-totp,ssh-key-vault-item,ssh-agent,export-attachments,mutual-tls
      '';
    };
  };
}
