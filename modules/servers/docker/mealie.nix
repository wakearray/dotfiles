{ lib, config, ... }:
let
  cfg = config.servers.docker.mealie;
in
{
  options.servers.docker.mealie = with lib; {
    enable = mkEnableOption "Enable an opinionated Mealie docker container.";

    defaultGroup = mkOption {
      type = types.str;
      default = "Home";
      description = "The default group for users.";
    };

    defaultHousehold = mkOption {
      type = types.str;
      default = "Family";
      description = "The default group for users.";
    };

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "The domain you want mealie hosted at.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "recipes";
      description = "The subdomain you want mealie hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 9925;
      description = "The local port you want mealie hosted at.";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "/var/lib/mealie";
      description = "String of path to where you want the Mealie's data to be located.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be a complete environment file named `mealieEnvironmentVars`.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      mealie = {
        image = "ghcr.io/mealie-recipes/mealie:latest";
        ports = [ "127.0.0.1:${toString cfg.localPort}:9000" ];
        environmentFiles = [ config.sops.templates."mealie.env".path ];
        volumes = [ "${cfg.dataFolder}/mealie-app:/app/data/" ];
        dependsOn = [ "mealie-postgres" ];
        extraOptions = [ "--network=mealie-network" ];
      };

      mealie-postgres = {
        image = "postgres:17";
        environmentFiles = [ config.sops.templates."mealie-postgres.env".path ];
        volumes = [ "${cfg.dataFolder}/postgres:/var/lib/postgresql/data" ];
        extraOptions = [
          "--health-cmd=pg_isready"
          "--health-interval=30s"
          "--health-timeout=20s"
          "--health-retries=3"
          "--network=mealie-network"
        ];
      };
    };

    sops = {
      secrets = let
        opts = { sopsFile = cfg.sopsFile; };
      in
      {
        #postgresUser = opts;
        mealiePostgresPassword = opts;

        mealieSmtpUser = opts;
        mealieSmtpPassword = opts;

        mealieOidcClientSecret = opts;
      };

      templates = let
        ph = config.sops.placeholder;
      in
      {
        "mealie-postgres.env".content = ''
          POSTGRES_USER=mealie
          POSTGRES_PASSWORD=${ph.mealiePostgresPassword}
          PGUSER=mealie
          POSTGRES_DB=mealie
        '';

        "mealie.env".content = ''
          ALLOW_SIGNUP=false
          PUID=1000
          PGID=1000
          DEFAULT_GROUP=${cfg.defaultGroup}
          DEFAULT_HOUSEHOLD=${cfg.defaultHousehold}
          TZ=${config.time.timeZone}
          BASE_URL=https://${cfg.subdomain}.${cfg.domain}

          DB_ENGINE=postgres
          POSTGRES_USER=mealie
          POSTGRES_PASSWORD=${ph.mealiePostgresPassword}
          POSTGRES_SERVER=mealie-postgres
          POSTGRES_PORT=5432
          POSTGRES_DB=mealie

          SMTP_HOST=mail.smtp2go.com
          SMTP_PORT=2525
          SMTP_FROM_NAME="Recipies at Voiceless Crimson"
          SMTP_AUTH_STRATEGY=TLS # Options: 'TLS', 'SSL', 'NONE'
          SMTP_FROM_EMAIL=noreply@${cfg.domain}
          SMTP_USER=${ph.mealieSmtpUser}
          SMTP_PASSWORD=${ph.mealieSmtpPassword}

          OIDC_AUTH_ENABLED=true
          OIDC_SIGNUP_ENABLED=true
          OIDC_CONFIGURATION_URL=https://idm.voicelesscrimson.com/oauth2/openid/mealie/.well-known/openid-configuration
          OIDC_CLIENT_ID=mealie
          OIDC_CLIENT_SECRET=${ph.mealieOidcClientSecret}
          OIDC_PROVIDER_NAME=Kanidm
          OIDC_AUTO_REDIRECT=false
          #OIDC_USER_CLAIM=preferred_username
          OIDC_GROUPS_CLAIM=groups
          OIDC_ADMIN_GROUP=mealie_admins@idm.voicelesscrimson.com
          OIDC_USER_GROUP=mealie_users@idm.voicelesscrimson.com
        '';
      };
    };

    systemd.services.init-mealie-network = {
      description = "Create the mealie-network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "mealie-network" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create mealie-network
        else
          echo "mealie-network already exists in docker"
        fi
      '';
    };

    # Docker Container Update Timer
    systemd.services."updateMealieDockerImage" = {
      description = "Pull latest Docker image and restart services";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        ${dockercli} pull ghcr.io/mealie-recipes/mealie:latest
        systemctl restart docker-mealie.service
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Define the timer
    systemd.timers.updateMealieDockerImageTimer = {
      description = "Daily timer to pull latest Docker image for Mealie and restart services";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "06:00:00";
        Persistent = true; # Ensures the timer catches up if it missed a run
        Unit = "updateMealieDockerImage.service";
      };
    };
  };
}
