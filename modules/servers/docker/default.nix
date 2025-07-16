{ lib, config, pkgs, ... }:
{
  # when creating new containers, ensure the `ports` argument always starts with
  # "127.0.0.1:" otherwise Docker will attempt to open external ports in iptables
  # regardless of other firewall rules.

  imports = [
    ./lobechat.nix
    ./tubearchivist.nix
    ./wger.nix
  ];

  options.servers.docker = {
    enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf config.servers.docker.enable {
    environment.systemPackages = with pkgs; [
      bridge-utils
      docker-client
      docker-compose

      # Oxker - A simple tui to view & control docker containers
      # https://github.com/mrjackwills/oxker
      oxker
    ];

    virtualisation = {
      # Enable docker deamon
      docker = {
        enable = false;
        enableOnBoot = false;
        daemon.settings = {
          pruning = {
            enabled = true;
            interval = "24h";
          };
        };
      };
      podman = {
        enable = true;
        dockerCompat = true;
        autoPrune = {
          enabled = true;
          dates = "weekly";
        };
      };
      oci-containers.backend = "podman";
    };
    servers.nginx.enable = true;
  };
}
