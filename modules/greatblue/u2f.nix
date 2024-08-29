{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Allows me to use U2F/FIDO2 USB keys
    pam_u2f
  ];

  # Security
  security = {
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        authFile = "/etc/u2f_mappings";
        appId = "pam://NixOS";
        origin = "pam://NixOS";
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        su.u2fAuth = true;
        gdm-launch-environment.u2fAuth = true;
        gdm-password.u2fAuth = true;
        polkit-1.u2fAuth = true;
      };
    };
  };
}
