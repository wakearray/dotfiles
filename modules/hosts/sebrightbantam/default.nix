{ pkgs, ... }:
{
  ## These are the defaults I want on SebrightBantam only:
  imports = [
    #./zigbee2mqtt.nix
    #./mosquitto.nix
    ./nginx
  ];

  config = {
    environment.systemPackages = with pkgs; [
      # CLI program to sync files to/from most cloud services
      rclone

      # Userspace file system mounting
      fuse3
    ];

    networking.firewall = {
      allowedTCPPorts = [
        # Rclone port for allowing rcloneui to connect
        5572
      ];
      allowedUDPPorts = [
        # Rclone port for allowing rcloneui to connect
        5572
      ];
    };
  };
}
