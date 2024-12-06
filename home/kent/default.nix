{ system-details, ... }:
{
  home = {
    username = "kent";
    homeDirectory = "/home/kent";
    stateVersion = "24.05";
  };

  imports = [
    ../common

    ./git.nix
    ./zellij.nix
    (if builtins.match "none" system-details.display-type != null then ./headless.nix else ./gui)
  ];

  programs.ssh.matchBlocks."*".user = "kent";
}
