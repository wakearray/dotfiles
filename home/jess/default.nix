{ config, ... }:
{
  imports = [
    ./starship.nix
    ../themes/catppuccin.nix
  ];

  home = {
    username = "jess";
    homeDirectory = "/home/jess";
    stateVersion = "24.05";
    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}";
    };
  };

  programs.ssh.matchBlocks."*".user = "jess";
}
