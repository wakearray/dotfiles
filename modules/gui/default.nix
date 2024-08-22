{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Defaults for any GUI specific applications that I want on every GUI capable computer
  imports = [
    ./sound.nix
  ];

  environment.systemPackages = with pkgs; [
    # Rust based teamviewer
    rustdesk-flutter
  ];

  fonts.packages = with pkgs; [
    # Better emojis
    twemoji-color-font

    # Nerdfonts
    unstable.nerdfonts
  ];
}
