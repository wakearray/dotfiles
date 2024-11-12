{ pkgs, ... }:
{
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
}
