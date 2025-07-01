{ pkgs, lib, config, ... }:
let
  gui = config.gui;
  onePass = gui._1pass;
in
{
  options.gui._1pass = with lib; {
    enable = mkEnableOption "Enable 1Password";

    sshAuthSock = mkEnableOption "Enable if you want to use SSH certificates that are stored inside the vault";

    polkitPolicyOwners = mkOption {
      type = types.listOf types.str;
      default = [ "nobody" ];
    };

    pamLogin = mkOption {
      type = types.bool;
      default = true;
      description = "Enable or disable automatically logging into gnome-keyring on user login.";
    };
  };

  config = lib.mkIf (gui.enable && onePass.enable) {
    environment.systemPackages = with pkgs; [
      # Password Management
      _1password-cli
      _1password-gui

      # Gnome Keyring is needed for 1Password to be able to store u2f tokens
      gnome-keyring
      libgnome-keyring
    ];

    # Runs gnome-keyring as root
    services.gnome.gnome-keyring.enable = true;

    # Logs into gnome-keyring on login
    security.pam.services.login.enableGnomeKeyring = true;

    # This has some issues when using it with VSCode and in other circumstances.
    environment.sessionVariables = lib.mkIf config.gui._1pass.sshAuthSock  {
      # Makes SSH work with 1Password
      SSH_AUTH_SOCK="~/.1password/agent.sock";
    };

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
