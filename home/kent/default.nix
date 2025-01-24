{ config, ... }:
let
  user = config.home.username;
in
{
  # /home/kent
  imports = [
    ./common
    ../common
    ../themes/gruvbox
  ];

  home = {
    username = "kent";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
  };

  programs.ssh.matchBlocks."*".user = user;
}
