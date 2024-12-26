{ pkgs, lib, config, ... }:
{
  options.gui._1pass = with lib; {
    enable = mkEnableOption "Enable 1Password";

    polkitPolicyOwners = mkOption {
      type = types.listOf types.str;
      default = [ "nobody" ];
    };
  };

  config = lib.mkIf (config.gui.enable && config.gui._1pass.enable) {
    environment.systemPackages = with pkgs; [
      # Password Management
      _1password-cli
      _1password-gui

      # Gnome Keyring is needed for 1Password to be able to store u2f tokens
      gnome-keyring
    ];

  #  # This has some issues
  #  environment.sessionVariables = {
  #    # Makes SSH work with 1Password
  #    SSH_AUTH_SOCK="~/.1password/agent.sock";
  #  };

    # Make 1Password work correctly
    programs = {
      _1password = {
        enable = true;
        package = pkgs._1password-cli;
      };
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = config.gui._1pass.polkitPolicyOwners;
        package = pkgs._1password-gui;
      };
    };
  };
}
