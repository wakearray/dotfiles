{ ... }:
{
  # A standalone home-manager file for aarch64 Android devices
  # Using either Arch or Debian with the Nix package manager and home-manager

  imports = [
    #./syncthing.nix
    ./starship.nix
    ./gui
  ];
}
