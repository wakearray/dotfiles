{ config, ... }:
let
  user = config.home.username;
in
{
  home = {
    username = "kent";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
  };

  imports = [
    ../common
    ./common
  ];

  programs.ssh.matchBlocks."*".user = user;
}
