{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  mpv = gui.mpv;
in
{
  options.gui.mpv = with lib; {
    enable = mkEnableOption "Enable an opinionated mpv config.";
  };

  config = lib.mkIf (gui.enable && mpv.enable) {
    programs.mpv = {
      enable = true;
      bindings = {
        PLAYPAUSE = "cycle pause";
      };
      #config = {};
      #profiles = {};
      #scripts = [];
      #scriptOpts = {};
    };

    home.packages = with pkgs; [
      # mpvc - A mpc-like control interface for mpv
      # https://github.com/lwilletts/mpvc
      mpvc
    ];
  };
}
