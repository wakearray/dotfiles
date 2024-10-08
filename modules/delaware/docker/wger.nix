{ domain, ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      wger = {
        image = "wger/server:latest";
        dependsOn = [ "db" "cache" ];
        environmentFiles = [ ./config/prod.env ];
        volumes = [
          "static:/home/wger/static"
          "media:/home/wger/media"
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
      nginx = {
        image = "nginx:stable";
        dependsOn = [ "wger" ];
        volumes = [
          "./config/nginx.conf:/etc/nginx/conf.d/default.conf"
          "static:/wger/static:ro"
          "media:/wger/media:ro"
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
      db = {
        image = "postgres:15-alpine";
        environment = {
          POSTGRES_USER = "wger";
          POSTGRES_PASSWORD = "wger";
          POSTGRES_DB = "wger";
        };
        volumes = [
          "postgres-data:/var/lib/postgresql/data/"
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
      cache = {
        image = "redis";
        ports = [ "6379" ];
        volumes = [
          "redis-data:/data"
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
      celery_worker = {
        image = "wger/server:latest";
        cmd = [ "/start-worker" ];
        environmentFiles = [ ./config/prod.env ];
        volumes = [
          "media:/home/wger/media"
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
      celery_beat = {
        image = "wger/server:latest";
        cmd = [ "/start-beat" ];
        volumes = [
          "celery-beat:/home/wger/beat/"
        ];
        environmentFiles = [ ./config/prod.env ];
        dependsOn = [ "celery_worker" ];
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
}
