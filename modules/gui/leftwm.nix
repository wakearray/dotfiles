{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  services.xserver.windowManager.leftwm.enable = true;

  environment.systemPackages = with pkgs; [

  ];
}
