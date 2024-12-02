{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Password Management
    unstable._1password
    unstable._1password-gui
  ];

#  # This has some issues
#  environment.sessionVariables = {
#    # Makes SSH work with 1Password
#    SSH_AUTH_SOCK="~/.1password/agent.sock";
#  };

  # Make 1 Password work correctly
  programs = {
    _1password = {
      enable = true;
      package = pkgs.unstable._1password;
    };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "kent" ];
      package = pkgs.unstable._1password-gui;
    };
  };
}
