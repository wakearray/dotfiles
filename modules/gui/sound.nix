{ lib, config, pkgs, ... }:
let
  gui = config.gui;
in
{
  config = lib.mkIf gui.enable {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };
    environment.systemPackages = [
      pkgs.pamixer
    ];
  };
}
