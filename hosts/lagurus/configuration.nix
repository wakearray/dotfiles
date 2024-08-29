{ config, pkgs, ... }:

{
  imports =
  [ 
    ./hardware-configuration.nix
    ../../modules
    ../../modules/gui
    ../../modules/gui/sway.nix

    ../../users/kent
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "Lagurus";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  systemd.user.services.catvideo = {
    description = "plays a video";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = let vlc = "${pkgs.vlc}/bin/vlc";
    in ''
      #!/bin/sh
      ${vlc} -L -f /home/kent/Desktop/string_video.webm
    '';
    wantedBy = [ "multi-user.target" ]; # starts after login
  };

  system.stateVersion = "23.11";
}
