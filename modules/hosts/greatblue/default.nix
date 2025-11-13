{ pkgs, ... }:
{
  ## These are the defaults I want on GreatBlue only:
  imports =
  [
    ./fingerprint_reader.nix
    #./sunshine.nix
    ./tui.nix
    ./u2f.nix
  ];

  gui = {
    enable = true;
    _1pass.enable = true;
    syncthing = {
      enable = true;
      user = "kent";
      sopsFile = ./syncthing.yaml;
    };
    gaming.enable = true;
    office.enable = true;
    #print.enable = true;
    wm.hyprland.enable = true;
    greeter.tuigreet.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # GPD Specific Tool:
    # RyzenAdj for controlling many RyzenCPU/APU/GPU power settings
    # https://github.com/FlyGoat/RyzenAdj
    ryzenadj

    # Drivers to support docks with HDMI ports
    #displaylink

    # Generate Nix packages from URLs
    # https://github.com/nix-community/nix-init
    nix-init

    # Collection of image builders
    # https://github.com/nix-community/nixos-generators
    nixos-generators

    # Kdenlive is video editing software
    kdePackages.kdenlive
    # Vector animation tool that works with kdenlive
    # glaxnimate

    # Keyboard firmware
    #via
    vial

    # Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win
    # https://github.com/hhd-dev/hhd
    # handheld-daemon

    # For playing audio from one device on another
    soundwireserver

    # OpenSCAD
    stable.openscad-unstable

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg_7-full
  ];

  services = {
    # Needed to make NixOS work with displaylink docks
    #xserver.videoDrivers = [ "displaylink" "modesetting" ];
    # Let the window manager choose how to handle lid open/close events
    logind.settings.Login.HandleLidSwitch = "ignore";
  };

  # Enables kernel module needed for ryzenadj to work
  hardware.cpu.amd.ryzen-smu.enable = true;

  virtualisation.virtualbox.host.enable = true;
}
