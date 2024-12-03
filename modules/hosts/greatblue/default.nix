{ pkgs, ... }:
{
  ## These are the defaults I want on GreatBlue only:
  imports =
  [
    ./8bitdo.nix
    ./fingerprint_reader.nix
    ./syncthing.nix
    ./tui.nix
    ./u2f.nix
  ];

  gui = {
    enable = true;
    _1pass = {
      enable = true;
      polkitPolicyOwners = [ "kent" ];
    };
    gaming.enable = true;
    wm.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # GPD Specific Tool:
    # RyzenAdj for controlling many RyzenCPU/APU/GPU power settings
    # https://github.com/FlyGoat/RyzenAdj
    ryzenadj

    # Drivers to support docks with HDMI ports
    displaylink

    # Generate Nix packages from URLs
    # https://github.com/nix-community/nix-init
    nix-init

    # Collection of image builders
    # https://github.com/nix-community/nixos-generators
    nixos-generators

    android-studio

    # IDEs
    libsForQt5.kate

    # TTS
    piper-tts
    sox

    # Chat apps
    discord
    element-desktop
    telegram-desktop
    signal-desktop

    # Music
    tidal-hifi

    # Image editing
    gimp-with-plugins
    darktable
    rawtherapee
    exiftool
    inkscape

    # Kdenlive is video editing software
    libsForQt5.kdenlive
    # Vector animation tool that works with kdenlive
    # glaxnimate

    # Keyboard firmware
    via
    vial

    # Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win
    # https://github.com/hhd-dev/hhd
    # handheld-daemon

    # For playing audio from one device on another
    soundwireserver

    # OpenSCAD
    openscad-unstable

    xorg.xcbutil

    # Wayland things
    # Sirula - Simple app launcher for wayland written in rust
    # https://github.com/DorianRudolph/sirula
    # sirula <- Waiting on PR: https://github.com/NixOS/nixpkgs/pull/281963

    # utils
    usbutils
    android-tools

    # Internet browsers
    firefox
    google-chrome

    # Audio and video format converter
    ffmpeg_7-full
  ];
}
