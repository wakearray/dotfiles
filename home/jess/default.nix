{ config, ... }:
let
  user = config.home.username;
in
{
  imports = [
    ./common
    ../common
    ../themes/catppuccin.nix
  ];

  home = {
    username = "jess";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
  };

  programs.ssh.matchBlocks."*".user = user;
}
