{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment = {
    systemPackages = with pkgs; [
      # Password Management
      unstable._1password
      unstable._1password-gui
    ];
    # Environment variables
    sessionVariables = rec {
      # Makes SSH work with 1Password
      SSH_AUTH_SOCK="~/.1password/agent.sock";
    };
  };

  # Make 1 Password work correctly
  programs = {
    _1password = {
      enable = true;
    };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "jess" ];
    };
    git = {
      enable = true;
      config = [
        { init = { defaultBranch = "main"; }; }
        { user = {
          name = "KokiriChild";
          email = "e.with.mail@gmail.com";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDTbos7tHfhXlbGSg4l4j6AtT/9+xKtX6+6JANkndht";
        };}
        { gpg = { format = "ssh"; }; }
        { commit = { gpgsign = true; }; }
        { "gpg \"ssh\"" = { program = "${config.programs._1password-gui.package}/share/1password/op-ssh-sign"; }; }
        { color = { ui = "auto"; }; }
      ];
    };
  };
}
