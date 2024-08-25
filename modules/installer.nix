{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    nixos-install-tools
  ];
}
