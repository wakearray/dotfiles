{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  cliphist = gui.cliphist;
  isWayland = config.home.systemDetails.display.wayland;
in
{
  options.gui.cliphist = with lib; {
    enable = mkEnableOption "Enable cliphist, a wayland clipboard manager.";
  };

  config = lib.mkIf (gui.enable && (cliphist.enable && isWayland)) {
    services.cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
    };

    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
