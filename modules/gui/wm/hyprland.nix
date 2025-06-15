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
        withUWSM = true;
        #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
    };
  };
}
