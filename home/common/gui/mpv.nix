{ pkgs, ... }:
{
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
}
