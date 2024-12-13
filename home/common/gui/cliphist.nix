{ lib, config, pkgs, ... }:
{
  options.gui.cliphist = with lib; {
    enable = mkEnableOption "Enable cliphist, a wayland clipboard manager.";
  };

  config = lib.mkIf config.gui.cliphist.enable {
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
