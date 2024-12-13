{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.gui.wm.hyprland;
in
{
  options.gui.wm.hyprland = with lib; {
    enable = mkEnableOption "Enable hyperland with UWSM.";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
      hyprlock.enable = true;
    };

    security.pam.services.hyprlock = {};

    services = {
        playerctld = {
        enable = true;
      };
      # hypridle - hyprland's idle deamon
      # https://github.com/hyprwm/hypridle
      #hypridle.enable = true;
    };


    environment.systemPackages = [
      # A simple polkit authentication agent for Hyprland, written in QT/QML.
      # https://github.com/hyprwm/hyprpolkitagent
      pkgs.hyprpolkitagent
    ];

    # Compatibility settings:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
