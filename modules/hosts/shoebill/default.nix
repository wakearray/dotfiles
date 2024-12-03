{ pkgs, ... }:
{
  # Everything I want on Cichlid
  imports = [
    # Software related
    ./git.nix
    ./syncthing.nix
    ./jovian.nix
  ];

  gui = {
    enable = true;
    _1pass = {
      enable = true;
      polkitPolicyOwners = [ "jess" ];
    };
    wm.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # internet browsers
    firefox
    google-chrome

    # discord - an Electron wrapper for the Discord web client
    discord

    # Tidal - HiFi - An Electron wrapper for Tidal that
    # enables HiFi listening
    tidal-hifi

    # Signal-desktop - An Electron wrapper for Signal messenger
    signal-desktop
  ];
}
