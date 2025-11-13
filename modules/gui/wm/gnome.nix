{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  gnome = gui.wm.gnome;
in
{
  options.gui.wm.gnome = {
    enable = lib.mkEnableOption "Enable the Gnome desktop environment.";
  };

  config = lib.mkIf (gui.enable && gnome.enable) {
    # Enable the Gnome Desktop Environment using Wayland.
    services = {
      xserver = {
        enable = true;
        dpi = 300;
        desktopManager.gnome.enable = true;
        displayManager.gdm  = {
          enable = true;
          wayland = true;
        };
      };
    };

    # Style the KDE apps in Gnome drip.
    qt = {
      # null or one of "adwaita", "adwaita-dark", "adwaita-highcontrast", "adwaita-highcontrastinverse",
      # "bb10bright", "bb10dark", "breeze", "cde", "cleanlooks", "gtk2", "kvantum", "motif", "plastique"
      style = lib.mkOverride 1000 "adwaita-dark";
      platformTheme = lib.mkOverride 1000 "gnome";
      enable = true;
    };

    # Exclude certain Gnome packages.
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-connections
      epiphany # web browser
      geary # email reader
      evince # document viewer
    ];

    services.gnome.gnome-browser-connector.enable = true;

    environment.systemPackages = with pkgs; [
      # Gnome specific stuffs
      gnome-tweaks

      # Gnome Extensions
      gnomeExtensions.dash-to-panel
      gnome-menus

      polkit_gnome
    ];
  };
}
