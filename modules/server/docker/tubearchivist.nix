{ config, ... }:
{
  imports = [ ./docker.nix ];
  # TubeArchivist - A YouTube downloader and archival tool
  # https://docs.tubearchivist.com/installation/docker-compose/
  # https://github.com/tubearchivist/tubearchivist/blob/master/docker-compose.yml
  virtualisation.oci-containers.containers = {
    tubearchivist = {
      image = "bbilly1/tubearchivist";
      autoStart = true;
      ports = [ "8062:8000" ];
      volumes = [
        "media:/youtube"
        "cache:/cache"
      ];
      environment = {
        ES_URL = "http://archivist-es:9200";  # needs protocol e.g. http and port
        REDIS_HOST = "archivist-redis";       # don't add protocol
        HOST_UID = "1000";
        HOST_GID = "1000";
        TA_HOST = "tubearchivist.local";      # set your host name
        TA_USERNAME = "tubearchivist";        # your initial TA credentials
        TA_PASSWORD = "verysecret";           # your initial TA credentials
        ELASTIC_PASSWORD = "verysecret";      # set password for Elasticsearch
        TZ = "America/New_York";
      };
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
      image = "redis/redis-stack-server";
      autoStart = true;
      expose = [ "6379" ];
      volumes = [
        "redis:/data"
      ];
      dependsOn = [ "archivist-es" ];
      extraOptions = [ "--network=archivist-network" ];
    };

    archivist-es = {
      image = "bbilly1/tubearchivist-es";              # only for amd64, or use official es 8.14.3
      autoStart = true;
      environment = {
        ELASTIC_PASSWORD = "verysecret";               # matching Elasticsearch password
        ES_JAVA_OPTS = "-Xms1g -Xmx1g";
        "xpack.security.enabled" = "true";
        "discovery.type" = "single-node";
        "path.repo" = "/usr/share/elasticsearch/data/snapshot";
      };
      extraOptions = [
        "--ulimit memlock=-1:-1"
        "--network=archivist-network"
      ];
      volumes = [
        "es:/usr/share/elasticsearch/data"            # check for permission error when using bind mount, see readme
      ];
      expose = [ "9200" ];
    };
  };

  systemd.services.init-archivist-network = {
    description = "Create the archivist-network";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
    in ''
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
      ${dockercli} pull redis/redis-stack-server:latest
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
}
