{ lib, config, pkgs, ... }:
let
  hyprland = config.gui.wm.hyprland;
  #pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.gui.wm.hyprland = with lib; {
    enable = mkEnableOption "Enable hyprland with UWSM.";
  };

  config = lib.mkIf hyprland.enable {
#    nix.settings = {
#      substituters = ["https://hyprland.cachix.org"];
#      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
#    };

    programs = {
      hyprland = {
        enable = true;
        package = pkgs.stable.hyprland;
        withUWSM = true;
        portalPackage = pkgs.stable.xdg-desktop-portal-hyprland;
      };
      uwsm  = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/Hyprland";
          };
        };
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs.stable; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-wlr
        # You might also want to include other portals you need,
        # but ensure hyprland is prioritized for screensharing and similar features
      ];
      config = {
        hyprland = {
          # This explicitly tells applications using the portal
          # to use the "hyprland" backend for ScreenCast functionality.
          "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
          "org.freedesktop.impl.portal.RemoteDesktop" = "wlr";
          # You may need to add configurations for other portal interfaces
          # depending on the application and the specific functionality you're targeting.
          # For example, for file chooser:
          # "org.freedesktop.impl.portal.FileChooser" = "hyprland";
        };
        # You might need to configure other portals based on your needs
        # For example, to prioritize hyprland for certain functionalities if you have multiple portals enabled
        common = { "org.freedesktop.impl.portal.RemoteDesktop" = "wlr"; };
      };
    };

    gui.locker.gtklock.enable = true;

    hardware.graphics = {
      package = pkgs.mesa;
    };

    # A customizable lockscreen for hyprland
    # security.pam.services.hyprlock = {};

    # A simple polkit authentication agent for Hyprland, written in QT/QML.
    # https://github.com/hyprwm/hyprpolkitagent
    #security.polkit.package = pkgs.hyprpolkitagent;

    # Compatibility settings:
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      # Provides image preview in Yazi when running on Wayland
      systemPackages = [ pkgs.ueberzugpp ];
    };
  };
}
