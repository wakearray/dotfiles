{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  imports = [
    ./zsh.nix
    ./development_environments.nix
  ];
  home.enableNixpkgsReleaseCheck = false;
}
