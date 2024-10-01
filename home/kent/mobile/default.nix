{ pkgs, ... }:
{
  # A standalone home-manager file for aarch64 Android devices
  # Using either Arch or Debian with the Nix package manager and home-manager
  home.packages = with pkgs; [
    # packages
    firefox-esr
    discord
    tidal-hifi
    darktable
  ];


  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "0: term" = [{ class = "Alacritty"; }];
          "1: discord" = [{ class = "Discord"; }];
          "2: web" = [{ class = "Firefox"; }];
        };
      };
    };
  };
}
