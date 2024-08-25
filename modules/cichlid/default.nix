{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Everything I want on Cichlid
  imports = [
    # Harware related
    ./nvidia.nix
    ./rgb.nix

    # Software related
    ./git.nix
    ./syncthing.nix
    
    # GUI related
    ../gui
    ../gui/gnome.nix
    ../gui/steam.nix
  ];
  environment.systemPackages = with pkgs; [
    # vscodium - Open source source code editor developed 
    # by Microsoft for Windows, Linux and macOS 
    # (VS Code without MS branding/telemetry/licensing)
    # https://github.com/VSCodium/vscodium
    vscodium

    # Internet browsers
    firefox
    google-chrome

    # aspell - English spellcheck
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    # SSH File System for mounting remote storage over SSH
    sshfs

    # Discord - An Electron wrapper for the Discord web client
    discord

    # Tidal - HiFi - An Electron wrapper for Tidal that 
    # enables HiFi listening
    tidal-hifi

    # Alacritty - A GPU accelerated terminal written in Rust
    # https://github.com/alacritty/alacritty
    unstable.alacritty
    unstable.alacritty-theme
  ];
}
