{ config, pkgs, ... }:
{
  home = {
    username = "entertainment";
    homeDirectory = "/home/entertainment";
    stateVersion = "24.05";

    packages = with pkgs; [
      # packages
      firefox-esr
      tidal-hifi
    ];

    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}";
    };
  };
}
