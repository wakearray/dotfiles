{ ... }:
{
  imports = [
    (
      # Put the most recent revision here:
      let revision = "4b1c28efe3b31e00c427e651b398d8251dd29812"; in
      builtins.fetchTarball {
        url = "https://github.com/Jovian-Experiments/Jovian-NixOS/archive/${revision}.tar.gz";
        # Update the hash as needed:
        sha256 = "sha256:1mfq2iyd34qy5ibmzmy63hq76q7yqamkw5n6xakga5wwkpv0w2sc";
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

      desktopSession = "steam";

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
    };
    decky-loader = {
      enable = true;
      # extraPackages = [];
      # extraPythonPackages = [];
    };
    hardware.has.amd.gpu = true;
  };
}
