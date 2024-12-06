{ config, pkgs, ... }:

{
  imports = [
    ./starship.nix
    ../themes/catppuccin.nix
  ];

  home = {
    username = "jess";
    homeDirectory = "/home/jess";
    stateVersion = "24.05";
    packages = with pkgs; [
      # aseprite - Animated sprite editor & pixel art tool
      # https://www.aseprite.org/
      aseprite
    ];
    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}";
    };
  };

  programs.ssh.matchBlocks."*".user = "jess";
}
