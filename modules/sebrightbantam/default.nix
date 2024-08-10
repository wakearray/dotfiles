{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  ## These are the defaults I want on GreatBlue only:
  imports = [
    ./home-assistant.nix
  ];

  environment.systemPackages = [

  ];
}
