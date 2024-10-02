{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixos-install-tools
  ];
}
