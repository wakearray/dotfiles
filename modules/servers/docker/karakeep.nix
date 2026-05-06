{ pkgs, lib, config, ... }:
let
  cfg = config.servers.docker.karakeep;
in
{
  options.servers.docker.karakeep = with lib; {
    enable = mkEnableOption "Enable an opinionated Karakeep Docker config";

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "The domain you want Karakeep hosted at.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "pin";
      description = "The subdomain you want Karakeep hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 3000;
      description = "The local port you want Karakeep hosted at.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be a complete environment file named `karakeepEnvironmentVars`.";
    };
  };

  # WIP
  # Needs secrets management
  # Needs separate nginx
  # Needs thorough reading of settings
  # Needs env file for web and search containers
  # Needs OIDC
  config = lib.mkIf cfg.enable {
    # Docker Karakeep Chrome
    virtualisation.oci-containers.containers."karakeep-chrome" = {
      image = "gcr.io/zenika-hub/alpine-chrome:124";
      cmd = [
        "--no-sandbox"
        "--disable-gpu"
        "--disable-dev-shm-usage"
        "--remote-debugging-address=0.0.0.0"
        "--remote-debugging-port=9222"
        "--hide-scrollbars"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=chrome"
        "--network=karakeep_default"
      ];
    };
    systemd.services."docker-karakeep-chrome" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
      after = [
        "docker-network-karakeep_default.service"
      ];
      requires = [
        "docker-network-karakeep_default.service"
      ];
      partOf = [
        "docker-compose-karakeep-root.target"
      ];
      wantedBy = [
        "docker-compose-karakeep-root.target"
      ];
    };

    # Docker Karakeep Meilisearch
    virtualisation.oci-containers.containers."karakeep-meilisearch" = {
      image = "getmeili/meilisearch:v1.41.0";
      environment = {
        "MEILI_NO_ANALYTICS" = "true";
      };
      volumes = [
        "karakeep_meilisearch:/meili_data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=meilisearch"
        "--network=karakeep_default"
      ];
    };
    systemd.services."docker-karakeep-meilisearch" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
      after = [
        "docker-network-karakeep_default.service"
        "docker-volume-karakeep_meilisearch.service"
      ];
      requires = [
        "docker-network-karakeep_default.service"
        "docker-volume-karakeep_meilisearch.service"
      ];
      partOf = [
        "docker-compose-karakeep-root.target"
      ];
      wantedBy = [
        "docker-compose-karakeep-root.target"
      ];
    };

    # Docker Karakeep Web
    virtualisation.oci-containers.containers."karakeep-web" = {
      image = "ghcr.io/karakeep-app/karakeep:release";
      environment = {
        "BROWSER_WEB_URL" = "http://chrome:9222";
        "DATA_DIR" = "/data";
        "MEILI_ADDR" = "http://meilisearch:7700";
      };
      volumes = [
        "karakeep_data:/data:rw"
      ];
      ports = [
        "3000:3000/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=web"
        "--network=karakeep_default"
      ];
    };
    systemd.services."docker-karakeep-web" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
      after = [
        "docker-network-karakeep_default.service"
        "docker-volume-karakeep_data.service"
      ];
      requires = [
        "docker-network-karakeep_default.service"
        "docker-volume-karakeep_data.service"
      ];
      partOf = [
        "docker-compose-karakeep-root.target"
      ];
      wantedBy = [
        "docker-compose-karakeep-root.target"
      ];
    };

    # Networks
    systemd.services."docker-network-karakeep_default" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "docker network rm -f karakeep_default";
      };
      script = ''
        docker network inspect karakeep_default || docker network create karakeep_default
      '';
      partOf = [ "docker-compose-karakeep-root.target" ];
      wantedBy = [ "docker-compose-karakeep-root.target" ];
    };

    # Volumes
    systemd.services."docker-volume-karakeep_data" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect karakeep_data || docker volume create karakeep_data
      '';
      partOf = [ "docker-compose-karakeep-root.target" ];
      wantedBy = [ "docker-compose-karakeep-root.target" ];
    };
    systemd.services."docker-volume-karakeep_meilisearch" = {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        docker volume inspect karakeep_meilisearch || docker volume create karakeep_meilisearch
      '';
      partOf = [ "docker-compose-karakeep-root.target" ];
      wantedBy = [ "docker-compose-karakeep-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."docker-compose-karakeep-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
