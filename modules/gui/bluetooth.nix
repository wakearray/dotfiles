{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.hardware.bluetooth.enable {
    # Bluetooth options
    hardware.bluetooth = {
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      # bluetui - TUI for managing bluetooth on Linux
      # https://github.com/pythops/bluetui
      bluetui

      # A TUI bluetooth manager for Linux
      # https://github.com/bluetuith-org/bluetuith
      bluetuith

      # Bluetooth GUI written in Rust
      # https://github.com/kaii-lb/overskride
      overskride
    ];
  };
}
