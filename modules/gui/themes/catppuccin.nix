{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Bootloader.
  boot = {
    plymouth = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
    };
  };

  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "macchiato";
  };

  console.catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  # https://github.com/catppuccin/sddm
  services.xserver = {
    displayManager.sddm = {
      enable = true;
      theme = lib.mkOverride 10 "catppuccin-macchiato";
      # Because this is overriding a setting set in gnome.nix
      # set it to a higher priority to override the other option
      package = lib.mkOverride 10 pkgs.kdePackages.sddm;
    };
  };
}
