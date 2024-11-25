{ config, domain, ... }:
let
  # Docker Volumes
  static = "";
  media = "";
  nginxConf = "";
  postgres-data = "";
  redis-data = "";
  celery-beat = "";
in
{
  virtualisation.oci-containers = {
    containers = {
      wger = {
        image = "wger/server:latest";
        dependsOn = [ "wger-db" "wger-cache" ];
        environmentFiles = [ ./config/prod.env ];
        volumes = [
          "${static}:/home/wger/static"
          "${media}:/home/wger/media"
        ];
        ports = [ "8000" ];
        extraOptions = [
          "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:8000"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--health-start-period=300s"
          "--restart=unless-stopped"
        ];
      };
      wger-nginx = {
        image = "nginx:stable";
        dependsOn = [ "wger" ];
        volumes = [
          "${nginxConf}:/etc/nginx/conf.d/default.conf" # "./config/nginx.conf:/etc/nginx/conf.d/default.conf"
          "${static}:/wger/static:ro"
          "${media}:/wger/media:ro"
        ];
        ports = [ "8063:80" ];
        extraOptions = [
          "--health-cmd=service nginx status"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--health-start-period=30s"
          "--restart=unless-stopped"
        ];
      };
      wger-db = {
        image = "postgres:15-alpine";
        environment = {
          POSTGRES_USER = "wger";
          POSTGRES_PASSWORD = "wger";
          POSTGRES_DB = "wger";
        };
        volumes = [
          "${postgres-data}:/var/lib/postgresql/data/"
        ];
        ports = [ "5432" ];
        extraOptions = [
          "--health-cmd=pg_isready -U wger"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--health-start-period=30s"
          "--restart=unless-stopped"
        ];
      };
      wger-cache = {
        image = "redis";
        ports = [ "6379" ];
        volumes = [
          "${redis-data}:/data"
        ];
        extraOptions = [
          "--health-cmd=redis-cli ping"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--health-start-period=30s"
          "--restart=unless-stopped"
        ];
      };
      wger-celery-worker = {
        image = "wger/server:latest";
        cmd = [ "/start-worker" ];
        environmentFiles = [ ./config/prod.env ];
        volumes = [
          "${media}:/home/wger/media"
        ];
        dependsOn = [ "wger" ];
        extraOptions = [
          "--health-cmd=celery -A wger inspect ping"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--health-start-period=30s"
        ];
      };
      wger-celery-beat = {
        image = "wger/server:latest";
        cmd = [ "/start-beat" ];
        volumes = [
          "${celery-beat}:/home/wger/beat/"
        ];
        environmentFiles = [ ./config/prod.env ];
        dependsOn = [ "wger-celery-worker" ];
      };
    };
  };

  # Nginx reverse proxy
  services.nginx.virtualHosts = {
    "wger.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8063";
        };
      };
    };
  };

  systemd.services.init-wger-network = {
    description = "Create the wger-network";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
    in ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(${dockercli} network ls | grep "wger-network" || true)
      if [ -z "$check" ]; then
        ${dockercli} network create wger-network
      else
        echo "wger-network already exists in docker"
      fi
    '';
  };

  # Docker Container Update Timer
  systemd.services."updateWgerDockerImages" = {
    description = "Pull latest Docker images and restart services";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
    in ''
      ${dockercli} pull wger/server:latest
      ${dockercli} pull nginx:stable
      ${dockercli} pull postgres:15-alpine
      systemctl restart docker-wger-cache.service
      systemctl restart docker-wger-db.service
      systemctl restart docker-wger.service
      systemctl restart docker-wger-nginx.service
      systemctl restart docker-wger-celery-worker.service
      systemctl restart docker-wger-celery-beat.service
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  # Define the timer
  systemd.timers.updateWgerDockerImagesTimer = {
    description = "Daily timer to pull latest Docker images for Wger and restart services";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "06:00:00";
      Persistent = true; # Ensures the timer catches up if it missed a run
      Unit = "updateWgerDockerImages.service";
    };
  };
}
