{ lib, config, pkgs, ... }:
{
  options.servers.docker = {
    enable = lib.mkEnableOption "Docker";

    lobechat.enable = lib.mkEnableOption "LobeChat";

    tubearchivist.enable = lib.mkEnableOption "TubeArchivist";

    wger.enable = lib.mkEnableOption "Wger";
  };

  config = lib.mkIf config.servers.docker.enable {
    imports = [
      (if config.servers.docker.lobechat.enable then ./lobechat.nix else null)
      (if config.servers.docker.tubearchivist.enable then ./tubearchivist.nix else null)
      (if config.servers.docker.wger.enable then ./wger.nix else null)
    ];

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
