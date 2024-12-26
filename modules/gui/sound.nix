{ lib,
  config,
  pkgs,
  ... }:
{
  config = lib.mkIf config.gui.enable {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    environment.systemPackages = [
      pkgs.pamixer
    ];
  };
}
