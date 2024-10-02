{ config, pkgs, ... }:
let
  devices = import ./devices.nix;
in
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

  programs.ssh = {
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" ];
    hostKeyAlgorithms = [ "ssh-ed25519" ];
    knownHosts = {
      ${devices.cubot_p80.ip}.publicKey = devices.cubot_p80.key;
      ${devices.greatblue.ip}.publicKey = devices.greatblue.key;
      ${devices.cichlid.ip}.publicKey = devices.cichlid.key;
      ${devices.jerboa.ip}.publicKey = devices.jerboa.key;
      ${devices.delaware.ip}.publicKey = devices.delaware.key;
      ${devices.lagurus.ip}.publicKey = devices.lagurus.key;
      ${devices.sebright_bantam.ip}.publicKey = devices.sebright_bantam.key;
      ${devices.samsung_s24.ip}.publicKey = devices.samsung_s24.key;
      ${devices.lenovo_y700.ip}.publicKey = devices.lenovo_y700.key;
      ${devices.boox_air_nova_c.ip}.publicKey = devices.boox_air_nova_c.key;
      ${devices.hisense_a9.ip}.publicKey = devices.hisense_a9.key;
    };
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
