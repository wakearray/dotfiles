{ pkgs, ... }:
{
  ## These are the defaults I want on Starling only:
  imports =
  [
    ./tui.nix
    ./u2f.nix
  ];

  gui = {
    enable = true;
    _1pass.enable = true;
    gaming.enable = true;
    office.enable = true;
    syncthing = {
      enable = true;
      user = "kent";
      sopsFile = ./syncthing.yaml;
    };
    wm.hyprland.enable = true;
    greeter.tuigreet.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Drivers to support docks with HDMI ports
    displaylink

    # Generate Nix packages from URLs
    # https://github.com/nix-community/nix-init
    nix-init

    # Collection of image builders
    # https://github.com/nix-community/nixos-generators
    nixos-generators

    # Kdenlive is video editing software
    libsForQt5.kdenlive
    # Vector animation tool that works with kdenlive
    # glaxnimate

    # Keyboard firmware
    #via
    vial

    # For playing audio from one device on another
    soundwireserver

    # OpenSCAD
    openscad-unstable

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg-full
  ];

  services = {
    # Needed to make NixOS work with displaylink docks
    xserver.videoDrivers = [ "displaylink" "modesetting" ];
    # Let the window manager choose how to handle lid open/close events
    logind = {
      lidSwitch = "ignore";
      powerKey = "ignore";
      powerKeyLongPress = "poweroff";
    };
  };

  virtualisation.virtualbox.host.enable = true;
}
