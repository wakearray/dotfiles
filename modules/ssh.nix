{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };

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