{ lib, config, ... }:
{
  options.servers.docker.tubearchivist = {
    enable = lib.mkEnableOption "Enable TubeArchivist";
  };
  config = lib.mkIf config.servers.docker.tubearchivist.enable {
    # TubeArchivist - A YouTube downloader and archival tool
    # https://docs.tubearchivist.com/installation/docker-compose/
    # https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml
    virtualisation.oci-containers.containers = {
      tubearchivist = {
        image = "bbilly1/tubearchivist";
        autoStart = true;
        ports = [ "8062:8000" ];
        volumes = [
          "/data/tubearchivist/media:/youtube"
          "/data/tubearchivist/cache:/cache"
        ];
        environment = {
          ES_URL = "http://archivist-es:9200";  # needs protocol e.g. http and port
          REDIS_CON = "redis://archivist-redis:6379";
          HOST_UID = "1000";
          HOST_GID = "1000";
          TA_HOST = "http://192.168.0.46";      # set your host name
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
          "/data/tubearchivist/redis:/data"
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
          "/data/tubearchivist/es:/usr/share/elasticsearch/data"            # check for permission error when using bind mount, see readme
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
      '';
    };

    systemd.services.init-archivist-network = {
      description = "Create the archivist-network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # Ensures elastic search doesn't have permission errors
        chown 1000:0 -R /data/tubearchivist/es

        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "archivist-network" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create archivist-network
        else
          echo "archivist-network already exists in docker"
        fi
      '';
    };

    # Docker Container Update Timer
    systemd.services."updateArchivistDockerImages" = {
      description = "Pull latest Docker images and restart services";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        ${dockercli} pull bbilly1/tubearchivist:latest
        ${dockercli} pull bbilly1/tubearchivist-es:latest
        ${dockercli} pull redis:latest
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

    # Ensure nginx and docker are enabled
    servers = {
      docker.enable = true;
      nginx.enable = true;
    };
  };
}
