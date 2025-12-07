{ pkgs, ... }:
{
  ## These are the defaults I want on Moonfish only:
  imports = [
    ./sunshineSteam.nix
  ];

  servers.docker = {
    enable = false;
    gow = {
      wolf = {
        enable = false;
        renderNode = "/dev/dri/renderD128";
        gstDebug = 3;
        rustLog = "INFO";
      };
    };
  };

  sunshineSteam.enable = true;

  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    # For playing audio from one device on another
    soundwireserver

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg_7-full

    # Tool for AMD GPUs
    rocmPackages.rocm-smi
  ];

  virtualisation = {
    virtualbox.host.enable = true;
  };
}

