{ pkgs, ... }:
{
  ## These are the defaults I want on Moonfish only:
  imports = [ ];

  gui = {
    enable = true;
    # syncthing = {
    #   enable = true;
    #   user = "kent";
    #   sopsFile = ./syncthing.yaml;
    # };
    gaming.enable = true;
    wm.hyprland.enable = true;
    greeter.tuigreet.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # RyzenAdj for controlling many RyzenCPU/APU/GPU power settings
    # https://github.com/FlyGoat/RyzenAdj
    ryzenadj

    # For playing audio from one device on another
    soundwireserver

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg_7-full

    # Docker things
    bridge-utils
    docker-client
    docker-compose

    # Oxker - A simple tui to view & control docker containers
    # https://github.com/mrjackwills/oxker
    oxker
  ];

  services = { };

  # Enables kernel module needed for ryzenadj to work
  hardware.cpu.amd.ryzen-smu.enable = true;

  virtualisation = {
    virtualbox.host.enable = true;
    # Enable docker deamon
    docker.enable = true;
    oci-containers.backend = "docker";
  };
}

