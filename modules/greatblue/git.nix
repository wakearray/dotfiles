{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    # Password Management
    unstable._1password
    unstable._1password-gui
  ];

  # Environment variables
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];

    # Makes SSH work with 1Password
    SSH_AUTH_SOCK="~/.1password/agent.sock";
  };

  # Make 1 Password work correctly
  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "kent" ];
  };

  programs.git = {
    enable = true;
    config = [
      { init = { defaultBranch = "main"; }; }
      { user = {
        name = "Kent Hambrock";
        email = "Kent.Hambrock@gmail.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
      };}
      { gpg = { format = "ssh"; }; }
      { commit = { gpgsign = true; }; }
      { "gpg \"ssh\"" = { program = "${config.programs._1password-gui.package}/share/1password/op-ssh-sign"; }; }
      { color = { ui = "auto"; }; }
    ];
  };
}
