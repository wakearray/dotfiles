{ config, pkgs, ... }:

{
  home = {
    username = "kent";
    homeDirectory = "/home/kent";
    stateVersion = "24.05";
  };

  imports = [
  
  ];
  programs.home-manager.enable = true;
}
