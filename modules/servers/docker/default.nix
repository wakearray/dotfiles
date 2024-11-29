{ lib, config, pkgs, ... }:
{
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
    ];

    virtualisation = {
      # Enable virtualization.
      docker = {
        enable = true;
        enableOnBoot = true;
      };
      oci-containers.backend = "docker";
    };
    servers.nginx.enable = true;
  };
}
