{ pkgs, ... }:
{
  ## These are the defaults I want on GreatBlue only:
  imports =
  [
    ./8bitdo.nix
    ./fingerprint_reader.nix
    ./git.nix
    ./printers.nix
    ./samba.nix
    ./syncthing.nix
    ./tui.nix
    ./u2f.nix

    ../gui
    ../gui/steam.nix
    ../gui/gnome.nix
  ];

  environment.systemPackages = with pkgs; [
    # GPD Specific Tool:
    # RyzenAdj for controlling many RyzenCPU/APU/GPU power settings
    # https://github.com/FlyGoat/RyzenAdj
    unstable.ryzenadj

    # aspell
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    sshfs

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

    # Video player
    vlc

    # Atuin - Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
    # https://atuin.sh/
    unstable.atuin

    # TTS
    piper-tts
    sox

    # Chat apps
    discord
    element-desktop
    telegram-desktop

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
    # via
    vial

    # Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win
    # https://github.com/hhd-dev/hhd
    # unstable.handheld-daemon

    # For playing audio from one device on another
    soundwireserver

    # OpenSCAD
    unstable.openscad-unstable

    xorg.xcbutil

    # Wayland things
    # Sirula - Simple app launcher for wayland written in rust
    # https://github.com/DorianRudolph/sirula
    # sirula <- Waiting on PR: https://github.com/NixOS/nixpkgs/pull/281963

    # utils
    usbutils
    android-tools

    # Rust Tools
    #rustc

    # Internet browsers
    firefox
    google-chrome

    # commandline clipboad manipulation
    xclip

    # Audio and video format converter
    unstable.ffmpeg_7-full

    # Bash floating point maths
    bc

    # Alacritty -
    # https://github.com/alacritty/alacritty
    unstable.alacritty
    unstable.alacritty-theme
  ];

  home-manager.backupFileExtension = "backup";
}
