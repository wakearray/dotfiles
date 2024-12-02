{ system-details, ... }:
{
  # A standalone home-manager file for aarch64 Android devices
  # Using either Arch or Debian with the Nix package manager and home-manager

  imports = [
    ./mobilefonts.nix
    ./syncthing.nix
    ./starship.nix
    (
    if
      builtins.match "none" system-details.display-type != null
    then
      ./headless.nix
    else
      ./gui
    )
  ];

#  home = {
#    activation = {
#      # Home-Manager frequently kills ssh-agent and
#      # causes it to forget its keys
#      # So far this only sometimes helps
#      activateSshAgent = lib.hm.dag.entryAfter [
#        "installPackages"
#        "reloadSystemd"
#        "checkFilesChanged"
#        "onFilesChange"
#        "linkGeneration"
#      ] ''
#        run /usr/bin/sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
#      '';
#    };
#    file = {
#      "startup.sh" = {
#        #
#        text = ''
##!/bin/bash
## Setup ssh-agent
#if [[ -v SSH_AGENT_PID ]]; then
#  # ssh-agent is still running
#  echo "ssh-agent already running"
#  /usr/bin/ssh-add -l
#else
#  # ssh-agent was killed and needs to be started
#  eval "(/usr/bin/ssh-agent -s)"
#  sleep 2
#fi
#/usr/bin/ssh-add $HOME/.ssh/id_ed25519
#/usr/bin/ssh-add $HOME/.ssh/signing_key
#
## Load new .zshrc file
#source /home/kent/.zshrc
#        '';
#        enable = true;
#        executable = true;
#      };
#    };
#  };

  programs = {
    # chrooted Arch in Termux keeps forgetting the path
    zsh.envExtra = ''
PATH=/home/kent/.local/state/nix/profiles/profile/bin:/home/kent/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
    '';
  };
}
