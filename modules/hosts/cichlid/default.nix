{ pkgs, ... }:
{
  # Everything I want on Cichlid
  imports = [
    # Harware related
    ./nvidia.nix
    ./rgb.nix

    # Software related
    ./git.nix
    ./syncthing.nix
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
