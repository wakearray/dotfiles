{ lib, config, ... }:
let
  cfg = config.servers.docker.tubearchivist;
in
{
  options.servers.docker.tubearchivist = with lib; {
    enable = mkEnableOption "Enable TubeArchivist";

    host = mkOption {
      type = types.str;
      default = "http://192.168.0.46";
      description = "The URL you'll be accessing TubeArchivist on.";
    };

    localPort = mkOption {
      type = types.port;
      default = 8062;
      description = "The local port you want TubeArchivist hosted on.";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "/data/tubearchivist";
      description = "String of path to where you want the data to be located.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "";
    };
  };
  config = lib.mkIf cfg.enable {
    # TubeArchivist - A YouTube downloader and archival tool
    # https://docs.tubearchivist.com/installation/docker-compose/
    # https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml
    virtualisation.oci-containers.containers = {
      tubearchivist = {
        image = "bbilly1/tubearchivist";
        autoStart = true;
        ports = [ "${toString cfg.localPort}:8000" ];
        volumes = [
          "${cfg.dataFolder}/media:/youtube"
          "${cfg.dataFolder}/cache:/cache"
        ];
        environment = {
          ES_URL = "http://archivist-es:9200";  # needs protocol e.g. http and port
          REDIS_CON = "redis://archivist-redis:6379";
          HOST_UID = "1000";
          HOST_GID = "1000";
          TA_HOST = cfg.host;      # set your host name
          TZ = "America/New_York";
        };
        environmentFiles = [
          config.sops.templates."ta.env".path
        ];
        extraOptions = [
          "--health-cmd=curl -f http://localhost:8000/health"
          "--health-interval=2m"
          "--health-timeout=10s"
          "--health-retries=3"
          "--health-start-period=30s"
          "--network=archivist-network"
        ];
        dependsOn = [ "archivist-es" "archivist-redis" ];
      };

      archivist-redis = {
        image = "redis";
        autoStart = true;
        ports = [ "127.0.0.1:6379:6379" ];
        volumes = [
          "${cfg.dataFolder}/redis:/data"
        ];
        dependsOn = [ "archivist-es" ];
        extraOptions = [ "--network=archivist-network" ];
      };

      archivist-es = {
        image = "bbilly1/tubearchivist-es";              # only for amd64, or use official es 8.14.3
        autoStart = true;
        environment = {
          ES_JAVA_OPTS = "-Xms1g -Xmx1g";
          "xpack.security.enabled" = "true";
          "discovery.type" = "single-node";
          "path.repo" = "/usr/share/elasticsearch/data/snapshot";
        };
        environmentFiles = [
          config.sops.templates."ta.env".path
        ];
        extraOptions = [
          #"--ulimit memlock=-1:-1"
          "--network=archivist-network"
        ];
        volumes = [
          # If encountering permissions error, run `sudo chown 1000:0 -R /data/tubearchivist/es`
          "${cfg.dataFolder}/es:/usr/share/elasticsearch/data"            # check for permission error when using bind mount, see readme
        ];
        ports = [ "127.0.0.1:9200:9200" ];
      };
    };

    sops = {
      secrets = {
        ta_username = { sopsFile = ./tubearchivist.yaml; };
        ta_password = { sopsFile = ./tubearchivist.yaml; };
        elastic_password = { sopsFile = ./tubearchivist.yaml; };
      };

      templates."ta.env".content = ''
        # your initial TA credentials
        TA_USERNAME=${config.sops.placeholder.ta_username}
        # your initial TA credentials
        TA_PASSWORD=${config.sops.placeholder.ta_password}
        # set password for Elasticsearch
        ELASTIC_PASSWORD=${config.sops.placeholder.elastic_password}


        # Selects authentication backends. See potential values below.
        # Overrides TA_LDAP/TA_ENABLE_AUTH_PROXY.
        TA_LOGIN_AUTH_MODE=ldap_local # Default: single

        # deprecated (see below) Set to anything besides empty string to use
        # LDAP authentication instead of local user authentication.
        TA_LDAP=true # Default: false

        # Set to the uri of your LDAP server.
        TA_LDAP_SERVER_URI=ldap://idm.voicelesscrimson.com:389 # Default: null

        # Set to anything besides empty string to disable
        # certificate checking when connecting over LDAPS.
        TA_LDAP_DISABLE_CERT_CHECK=true # Default: null

        # DN of the user that is able to perform searches on your LDAP account.
        TA_LDAP_BIND_DN=uid=search-user,ou=users,dc=your-server # Default: null

        # Password for the search user.
        TA_LDAP_BIND_PASSWORD=yoursecretpassword # Default: null

        # Bind attribute used to map LDAP user's username
        TA_LDAP_USER_ATTR_MAP_USERNAME=uid # Default: uid

        # Bind attribute used to match LDAP user's First Name/Personal Name.
        TA_LDAP_USER_ATTR_MAP_PERSONALNAME=givenName # Default: givenName

        # Bind attribute used to match LDAP user's Last Name/Surname.
        TA_LDAP_USER_ATTR_MAP_SURNAME=sn # Default: sn

        # Bind attribute used to match LDAP user's EMail address
        TA_LDAP_USER_ATTR_MAP_EMAIL=mail # Default: mail

        # Search base for user filter.
        TA_LDAP_USER_BASE=ou=users,dc=your-server # Default: null

        # Filter for valid users. Login usernames are matched using the attribute specified
        # in TA_LDAP_USER_ATTR_MAP_USERNAME and should not be specified in this filter.
        TA_LDAP_USER_FILTER=(objectClass=user) # Default: null

        # Comma separated list of users (matched based on TA_LDAP_USER_ATTR_MAP_USERNAME)
        # which will automatically be promoted to superuser when they login.
        # Users given superuser access will also be given staff permissions.
        TA_LDAP_PROMOTE_USERNAMES_TO_SUPERUSER=alice,bob # Default: null

        # Comma separated list of users (matched based on TA_LDAP_USER_ATTR_MAP_USERNAME)
        # which will automatically be promoted to staff when they login.
        TA_LDAP_PROMOTE_USERNAMES_TO_STAFF=lisa,tom # Default: null
      '';
    };

    systemd.services.init-archivist-network = {
      description = "Create the archivist-network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      path = [ config.virtualisation.docker.package ];
      script = ''
        # Ensures elastic search doesn't have permission errors
        chown 1000:0 -R /data/tubearchivist/es

        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(docker network ls | grep "archivist-network" || true)
        if [ -z "$check" ]; then
          docker network create archivist-network
        else
          echo "archivist-network already exists in docker"
        fi
      '';
    };

    # Docker Container Update Timer
    systemd.services."updateArchivistDockerImages" = {
      description = "Pull latest Docker images and restart services";
      path = [ config.virtualisation.docker.package ];
      script = ''
        docker pull bbilly1/tubearchivist:latest
        docker pull bbilly1/tubearchivist-es:latest
        docker pull redis:latest
        systemctl restart docker-archivist-es.service
        systemctl restart docker-archivist-redis.service
        systemctl restart docker-tubearchivist.service
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Define the timer
    systemd.timers.updateArchivistDockerImagesTimer = {
      description = "Daily timer to pull latest Docker images for TubeArchivist and restart services";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "06:00:00";
        Persistent = true; # Ensures the timer catches up if it missed a run
        Unit = "updateArchivistDockerImages.service";
      };
    };

    # Ensure docker is enabled
    servers = {
      docker.enable = true;
    };
  };
}
