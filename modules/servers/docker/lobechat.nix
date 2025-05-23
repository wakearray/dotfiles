{ lib, config, ... }:
{
  options.servers.docker.lobechat = {
    enable = lib.mkEnableOption "Enable LobeChat docker image and systemd service.";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "lobe.localhost";
    };
  };
  config = lib.mkIf config.servers.docker.lobechat.enable {
    virtualisation = {
      oci-containers = {
        containers = {
          # Redis server needed for bricksllm
          bricks-redis = {
            image = "redis:6.2-alpine";
            cmd = [ "redis-server" "--save" "20" "1" "--loglevel" "warning" "--requirepass" "eYVX7EwVmmxKPCDmwMtyKVge8oLd2t81" ];
            volumes = [
              "bricks-redis:/data"
            ];
            hostname = "bricks-redis";
            autoStart = true;
            extraOptions = [ "--network=lobechat-network" ];
          };
          # Postgresql server needed for bricksllm
          bricks-postgresql = {
            image = "postgres:14.1-alpine";
            environment = {
              POSTGRES_USER = "postgres";
              POSTGRES_PASSWORD = "postgres";
            };
            volumes = [
              "bricks-postgresql:/var/lib/postgresql/data"
            ];
            hostname = "bricks-postgresql";
            autoStart = true;
            extraOptions = [ "--network=lobechat-network" ];
          };
          # bricksllm - Enterprise-grade API gateway that helps you monitor and impose cost or rate limits per API key.
          # https://github.com/bricks-cloud/BricksLLM
          bricksllm = {
            image = "luyuanxin1995/bricksllm";
            cmd = [ "-m=dev" ];
            environment = {
              POSTGRESQL_USERNAME = "postgres";
              POSTGRESQL_PASSWORD = "postgres";
              REDIS_PASSWORD = "eYVX7EwVmmxKPCDmwMtyKVge8oLd2t81";
              POSTGRESQL_HOSTS = "bricks-postgresql";
              REDIS_HOSTS = "bricks-redis";
            };
            ports = [ "8001:8001" "8002:8002" ];
            dependsOn = [ "bricks-redis" "bricks-postgresql" ];
            hostname = "bricksllm";
            autoStart = true;
            extraOptions = [ "--network=lobechat-network" ];
          };
          # Lobe Chat - A web based frontend for LLM chatbots.
          # https://github.com/lobehub/lobe-chat
          lobe-chat = {
            image = "lobehub/lobe-chat";
            environment = {
              # Bricksllm local proxy
              OPENAI_PROXY_URL = "http://bricksllm:8002/api/providers/openai/v1";
              # Manually set the allowable models. These are also manually set in bricksllm
              CUSTOM_MODELS = "-all,+gpt-3.5-turbo-1106,+gpt-4o=gpt-4o";
            };
            ports = [ "3210:3210" ];
            dependsOn = [ "bricksllm" ];
            hostname = "Lobe-Chat";
            autoStart = true;
            extraOptions = [ "--network=lobechat-network" ];
          };
        };
      };
    };

    # Docker Lobechat network
    systemd.services.init-lobechat-network = {
      description = "Create the lobechat-network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "lobechat-network" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create lobechat-network
        else
          echo "lobechat-network already exists in docker"
        fi
      '';
    };

    # Docker Container Update Timer
    systemd.services."updateDockerImages" = {
      description = "Pull latest Docker images and restart services";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        ${dockercli} pull luyuanxin1995/bricksllm:latest
        ${dockercli} pull lobehub/lobe-chat:latest
        systemctl restart docker-bricksllm.service
        systemctl restart docker-lobe-chat.service
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Define the timer
    systemd.timers.updateDockerImagesTimer = {
      description = "Daily timer to pull latest Docker images and restart services";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "06:00:00";
        Persistent = true; # Ensures the timer catches up if it missed a run
        Unit = "updateDockerImages.service";
      };
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${config.servers.docker.lobechat.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:3210";
          };
        };
      };
    };
  };
}
