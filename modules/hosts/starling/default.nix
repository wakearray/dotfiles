{ pkgs, ... }:
{
  ## These are the defaults I want on Starling only:
  imports =
  [
    ./tui.nix
    ./u2f.nix
  ];

  sshfsMountsKent.enable = true;

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
    print.enable = true;
    greeter.tuigreet.enable = true;
  };

  environment.systemPackages = with pkgs; [
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

    # For playing audio from one device on another
    soundwireserver

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg-full
  ];

  # Starling can't complete full builds if this is enabled
  boot.tmp.useTmpfs = false;

  services = {
    # Let the window manager choose how to handle lid open/close events
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  virtualisation.virtualbox.host.enable = true;
}
