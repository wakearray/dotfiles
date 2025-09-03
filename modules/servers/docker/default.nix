{ lib, config, pkgs, ... }:
let
  cfg = config.servers.docker;
in
{
  # when creating new containers, ensure the `ports` argument always starts with
  # "127.0.0.1:" otherwise Docker will attempt to open external ports in iptables
  # regardless of other firewall rules.

  imports = [
    ./lobechat.nix
    ./omada-controller.nix
    ./tubearchivist.nix
    ./wger.nix
    ./wyze-bridge.nix
  ];

  options.servers.docker = {
    enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf cfg.enable {
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
      docker.enable = true;
      oci-containers.backend = "docker";
    };
  };
}
