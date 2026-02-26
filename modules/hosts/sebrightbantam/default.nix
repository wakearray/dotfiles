{ pkgs, ... }:
{
  ## These are the defaults I want on SebrightBantam only:
  imports = [
    #./zigbee2mqtt.nix
    #./mosquitto.nix
    ./nginx
  ];

  config = {
    environment.systemPackages = [
      pkgs.rclone
    ];
  };
}
