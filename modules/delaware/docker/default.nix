{ pkgs, ... }:
{
  imports = [
    ./lobechat.nix
    ./wyzecam-bridge.nix
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
