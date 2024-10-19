{ pkgs,
  lib,
  ... }:
{
  # A standalone home-manager file for aarch64 Android devices
  # Using either Arch or Debian with the Nix package manager and home-manager

  imports = [
    ./git.nix
    ./nix.nix
    ./mobilefonts.nix

    ./gui
  ];

  home = {
    packages = with pkgs; [
      # 7-Zip
      p7zip

      # SSH File System
      sshfs

      # Rust grep use `rg`
      repgrep
      ripgrep
      ripgrep-all

      # Rage - Rust implementation of age
      # https://github.com/str4d/rage
      rage

      # clipboard management
      xclip

      # nh - Yet another nix cli helper
      # https://github.com/viperML/nh/tree/master
      # Use `nh home switch .#kent@mobile` to rebuild home-manager derivation
      nh
    ];
    activation = {
      # Home-Manager frequently kills ssh-agent and
      # causes it to forget its keys
      # So far this only sometimes helps
      activateSshAgent = lib.hm.dag.entryAfter [
        "installPackages"
        "reloadSystemd"
        "checkFilesChanged"
        "onFilesChange"
        "linkGeneration"
      ] ''
        run sh ~/startup.sh
      '';
    };
    file = {
      "startup.sh" = {
        #
        text = ''
#!/bin/bash
# Setup ssh-agent
if [[ -v SSH_AGENT_PID ]]; then
  # ssh-agent is still running
  echo "ssh-agent already running"
  /usr/bin/ssh-add -l
else
  # ssh-agent was killed and needs to be started
  eval "(/usr/bin/ssh-agent -s)"
  sleep 2
fi
/usr/bin/ssh-add $HOME/.ssh/id_ed25519
/usr/bin/ssh-add $HOME/.ssh/signing_key

# Load new .zshrc file
source /home/kent/.zshrc
        '';
        enable = true;
        executable = true;
      };
    };
  };

  # Since we're not using NixOS
  targets.genericLinux.enable = true;

  programs = {
    # chrooted Arch in Termux keeps forgetting the path
    zsh.envExtra = ''
PATH=/home/kent/.local/state/nix/profiles/profile/bin:/home/kent/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
TZ='America/New_York'
    '';
  };

  # Fixes a haskell error
  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [ "en_US.UTF-8/UTF-8" ];
  };
}
