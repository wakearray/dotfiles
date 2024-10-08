{ pkgs, ... }:
{
  imports = [
    ./lobechat.nix
    ./wger.nix
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
  };
}
