{ lib, config, pkgs, ... }:
let
  cfg = config.gui.sound;
in
{
  options.gui.sound = with lib; {
    enable = mkEnableOption "Enable Pipewire audio using alsa." // { default = config.gui.enable; };
  };

  config = lib.mkIf cfg.enable {
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
      ## As sound is sometimes needed on headless hosts, non GUI sound programs should go here
      pkgs.pamixer

      # Simple TUI audio mixer for PipeWire
      # https://github.com/tsowell/wiremix
      pkgs.wiremix

    ] ++ lib.optionals config.gui.enable [
      ## And GUI based sound programs should go here

      # A pipewire audio mixer inspired by voicemeeter
      pkgs.pulsemeeter

      # GTK patchbay for pipewire
      pkgs.helvum

      # Low level control GUI for the PipeWire multimedia server
      # https://github.com/dimtpap/coppwr?tab=readme-ov-file
      pkgs.coppwr
    ];
  };
}
