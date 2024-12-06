{ ... }:
{
  home = {
    username = "kent";
    homeDirectory = "/home/kent";
    stateVersion = "24.05";
  };

  imports = [
    ../common
    ./common
  ];

  programs.ssh.matchBlocks."*".user = "kent";
}
