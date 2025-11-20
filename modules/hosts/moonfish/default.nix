{ pkgs, ... }:
{
  ## These are the defaults I want on Moonfish only:
  imports = [ ];

  servers.docker = {
    enable = true;
    gow = {
      wolf = {
        enable = true;
      };
    };
  };

  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    # For playing audio from one device on another
    soundwireserver

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg_7-full
  ];


  virtualisation = {
    virtualbox.host.enable = true;
    # Enable docker deamon
    docker.enable = true;
    oci-containers.backend = "docker";
  };
}

