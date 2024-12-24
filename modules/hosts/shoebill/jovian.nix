{ ... }:
{
  imports = [
    (
      # Put the most recent revision here:
      let revision = "8d7b2149e618696d5100c2683af1ffa893f02a75"; in
      builtins.fetchTarball {
        url = "https://github.com/Jovian-Experiments/Jovian-NixOS/archive/${revision}.tar.gz";
        # Update the hash as needed:
        sha256 = "sha256:0000000000000000000000000000000000000000000000000000";
      } + "/modules"
    )];

  # Jovian-NixOS settings
  # https://jovian-experiments.github.io/Jovian-NixOS/options.html
  jovian = {
    steam = {
      # Whether to enable the Steam Deck UI
      enable = true;

      # Make the SteamOS UI launch on startup
      # This is the default SteamDeck behavior
      autoStart = true;

      # Command to launch the Window Manager or DE
      desktopSession = "if uwsm check may-start; then exec uwsm start hyprland.desktop fi";

      # Environment variables to launch Steam with
      environment = {};

      # One of "steamos", "jovian", "vendor"
      updater.splash = "steamos";

      user = "jess";

    };
    devices.steamdeck = {
      # Enable Steam Deck-specific configurations
      enable = true;

      # Enable WiiU emulator Cemu to access the gyroscope
      # enableGyroDsuService = true;

      # Enable x11 to rotate the display
      enableXorgRotation = false;

      #
    };
    decky-loader = {
      enable = true;
      # extraPackages = [];
      # extraPythonPackages = [];
    };
    hardware.has.amd.gpu = true;
  };
}
