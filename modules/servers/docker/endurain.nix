{ lib, config, ... }:
let
  cfg = config.servers.docker.endurain;
in
{
  options.servers.docker.endurain = with lib; {
    enable = mkEnableOption "Enable an opinionated Endurain config.";

    #sameServerHost = mkEnableOption "If false, localPort will be exposed, if true it won't be.";

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "The domain your server will be hosted at.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "run";
      description = "The subdomain that your server will be hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 8080;
      description = "The local port you want endurain hosted at.";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "/var/lib/endurain";
      description = "String of path to where you want the data to be located.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "A SOPS secrets file with the following variables:
- `endurain_postgres_password`
- `endurain_secret_key`
- `endurain_fernet_key`
- `endurain_smtp_username`
- `endurain_smtp_password`";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      "endurain-postgres" = {
        image = "docker.io/postgres:17.5";
        environmentFiles = [ config.sops.templates."endurainPostgresEnvironmentFile".path ];
        extraOptions = [
          "--health-cmd=pg_isready -U endurain"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--network=endurain-network"
          "--network-alias=postgres"
        ];
        volumes = [
          "${cfg.dataFolder}/postgres/data:/var/lib/postgresql/data"
        ];
      };

      "endurain-app" = {
        image = "ghcr.io/endurain-project/endurain:latest";
        environmentFiles = [ config.sops.templates."endurainEnvironmentFile".path ];
        extraOptions = [
          "--network=endurain-network"
          "--network-alias=app"
        ];
        volumes = [
          "${cfg.dataFolder}/app/backend/data:/app/backend/data"
          "${cfg.dataFolder}/app/backend/logs:/app/backend/logs"
        ];
        ports = [ "${toString cfg.localPort}:8080" ];
        dependsOn = [ "endurain-postgres" ];
      };
    };

    systemd.services."docker-network-endurain" = {
      path = [ config.virtualisation.docker.package ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        docker network inspect endurain-network || docker network create endurain-network
      '';
      wantedBy = [ "multi-user.target" ];
    };

    # sops secrets
    sops.secrets = {
      endurain_postgres_password = { sopsFile = cfg.sopsFile; };
      endurain_secret_key = { sopsFile = cfg.sopsFile; };
      endurain_fernet_key = { sopsFile = cfg.sopsFile; };
      endurain_smtp_username = { sopsFile = cfg.sopsFile; };
      endurain_smtp_password = { sopsFile = cfg.sopsFile; };
    };

    sops.templates = {
      "endurainEnvironmentFile" = {
        content  = /*sh*/ ''

          # User ID for mounted volumes. Default is 1000
          UID=1000

          # Group ID for mounted volumes. Default is 1000
          GID=1000

          TZ=${config.time.timeZone}

          # You only need to change the directory values if installing using bare metal method
          FRONTEND_DIR=/app/frontend/dist
          BACKEND_DIR=/app/backend
          DATA_DIR=/app/backend/data
          LOGS_DIR=/app/backend/logs

          # Required for internal communication and Strava. For Strava https must be used.
          # Host or local ip (example: http://192.168.1.10:8080 or https://endurain.com)
          ENDURAIN_HOST=https://${cfg.subdomain}.${cfg.domain}

          ## Defines reverse geo provider.
          # Expects geocode, photon or nominatim.
          # photon can be the SaaS by komoot or a self hosted version like a self hosted version.
          # Like photon, Nominatim can be the SaaS or a self hosted version
          REVERSE_GEO_PROVIDER=nominatim

          # API host for photon. By default it uses the SaaS by komoot
          #PHOTON_API_HOST=photon.komoot.io
          # Protocol used by photon. By default uses HTTPS to be inline with what SaaS by komoot expects
          #PHOTON_API_USE_HTTPS=true

          # API host for Nominatim. By default it uses the SaaS
          NOMINATIM_API_HOST=nominatim.openstreetmap.org
          # Protocol used by Nominatim. By default uses HTTPS to be inline with what SaaS expects
          NOMINATIM_API_USE_HTTPS=true

          # Geocode maps offers a free plan consisting of 1 Request/Second. Registration necessary.
          #GEOCODES_MAPS_API=
          # Change this if you have a paid Geocode maps tier. Other providers also use this variable.
          # Keep it as is if you use photon or Nominatim to keep 1 request per second
          REVERSE_GEO_RATE_LIMIT=1

          # postgres
          DB_HOST=postgres
          DB_PORT=5432
          DB_USER=endurain
          DB_PASSWORD=${config.sops.placeholder.endurain_postgres_password}
          DB_DATABASE=endurain

          # Run openssl rand -hex 32 on a terminal to get a secret.
          SECRET_KEY=${config.sops.placeholder.endurain_secret_key}
          # `nix-shell -p "python3.withPackages (ps: [ps.cryptography])" --run "python3 -c 'from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())'"`
          FERNET_KEY=${config.sops.placeholder.endurain_fernet_key}
          # Currently only HS256 is supported
          ALGORITHM=HS256

          ACCESS_TOKEN_EXPIRE_MINUTES=15
          REFRESH_TOKEN_EXPIRE_DAYS=7

          # Enforce idle timeouts (supported values are true and false)
          SESSION_IDLE_TIMEOUT_ENABLED=false
          SESSION_IDLE_TIMEOUT_HOURS=1
          SESSION_ABSOLUTE_TIMEOUT_HOURS=24

          BEHIND_PROXY=true

          # production, demo and development allowed.
          # development allows connections from localhost:8080 and localhost:5173 at the CORS level.
          # demo equals to production except it does not return user sessions
          ENVIRONMENT=production

          # The SMTP settings
          SMTP_HOST=mail.smtp2go.com
          SMTP_PORT=2525
          SMTP_USERNAME=${config.sops.placeholder.endurain_smtp_username}
          SMTP_PASSWORD=${config.sops.placeholder.endurain_smtp_password}
          SMTP_SECURE=true
          SMTP_SECURE_TYPE=starttls

          # Supported levels: critical, error, warning, info, debug, trace
          LOG_LEVEL=info
        '';
      };

      "endurainPostgresEnvironmentFile" = {
        content = /*sh*/ ''
          POSTGRES_PASSWORD=${config.sops.placeholder.endurain_postgres_password}
          POSTGRES_DB=endurain
          POSTGRES_USER=endurain
          PGDATA=/var/lib/postgresql/data/pgdata
        '';
      };
    };
  };
}
