{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Password Management
    unstable._1password
    unstable._1password-gui
  ];

  # Environment variables
  environment.sessionVariables = {
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
