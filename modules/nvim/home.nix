{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  imports = [
    #./nvim.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
