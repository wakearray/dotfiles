{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  security.polkit.enable = true;
  
  environment.systemPackages = with pkgs; [

  ];
}
