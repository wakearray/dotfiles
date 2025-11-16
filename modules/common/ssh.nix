{ lib, pkgs, ... }:
{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security, allow settings to be override for making custom installer images
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      KbdInteractiveAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "no";
    };
    openFirewall = true;
  };

  programs.ssh = {
    # Currently being set to gnome-keyring in the 1password config
    # You cannot have two sshAgents running at the same time and gnome-keyring is required for 1Pass
    #startAgent = lib.mkDefault true;
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" ];
    hostKeyAlgorithms = [ "ssh-ed25519" ];
  };

  environment.systemPackages = with pkgs; [
    sshfs
  ];

  # the calling user’s SSH agent is used to authenticate against the keys
  # in the calling user’s ~/.ssh/authorized_keys.
  # This is useful for sudo on password-less remote systems.
  security = {
    pam = {
      sshAgentAuth.enable = true;
      services.sudo.sshAgentAuth = true;
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
