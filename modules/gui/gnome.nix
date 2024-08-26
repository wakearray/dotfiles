{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
{
  # Enable the Gnome Desktop Environment using Wayland.
  services.xserver = {
    enable = true;
    dpi = 300;
    displayManager = {
      sddm = {
        enable = true;
        wayland = true;
      };
    };
    videoDrivers = [ "displaylink" "modesetting" ];
    desktopManager.gnome.enable = true;
  };

  # Style the KDE apps in Gnome drip.
  qt = {
    # null or one of "adwaita", "adwaita-dark", "adwaita-highcontrast", "adwaita-highcontrastinverse",
    # "bb10bright", "bb10dark", "breeze", "cde", "cleanlooks", "gtk2", "kvantum", "motif", "plastique"
    style = "adwaita-dark";
    platformTheme = "gnome";
    enable = true;
  };

  # Exclude certain Gnome packages.
  environment.gnome.excludePackages = (with pkgs; [
    # for packages that are pkgs.***
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    # for packages that are pkgs.gnome.***
    epiphany # web browser
    geary # email reader
    evince # document viewer
  ]);

  services.gnome.gnome-browser-connector.enable = true;

  environment.systemPackages = with pkgs; [
    # Rofi - Window switcher, run dialog and dmenu replacement for Wayland
    # https://github.com/lbonn/rofi
    rofi-wayland
    # Tiny dynamic menu for Wayland
    # https://github.com/philj56/tofi
    tofi

    # Gnome specific stuffs
    gnome.gnome-tweaks

    # Gnome Extensions
    gnomeExtensions.dash-to-panel
    gnome-menus

    unstable.polkit_gnome
  ];
}
