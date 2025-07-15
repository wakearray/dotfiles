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
      # Enable virtualization.
      docker = {
        enable = true;
        enableOnBoot = true;
        daemon.settings = {
          pruning = {
            enabled = true;
            interval = "24h";
          };
        };
      };
      oci-containers.backend = "docker";
    };
    servers.nginx.enable = true;
  };
}
