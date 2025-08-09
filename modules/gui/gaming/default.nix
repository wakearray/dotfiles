{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  gaming = gui.gaming;
in
{
  imports = [ ./sunshine.nix ];

  options.gui.gaming = {
    enable = lib.mkEnableOption "Enable Steam, GOG, etc.";
  };

  config = lib.mkIf (gui.enable && gaming.enable) {
    programs = {
      # Enable Steam
      steam = {
        enable = true;
        # SteamOS' micro-compositor. Can be used for compatability improvements. To use,
        # change steam Launch Options on per game basis to `gamescope %command%`
        # https://github.com/ValveSoftware/gamescope
        gamescopeSession.enable = true;

        # A simple wrapper for running Winetricks commands for Proton-enabled games.
        protontricks.enable = true;

        # Proton-GE is an open source experimentally patched version of proton
        # Sometimes necessary for newer games.
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
      # Scripts to get better performance when gaming. To use,
      # change steam Launch Options on per game basis to `gamemoderun %command%`
      # https://github.com/FeralInteractive/gamemode
      gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Steam container with FHS support
      steam-run

      # Game launcher with access to Steam, GOG, Epic, and Humble Bundle
      # https://github.com/lutris/lutris
      lutris

      # Game launcher with access to Epic, GOG, and Amazon Games
      # https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher
      heroic

      # Unofficial GOG downloader that uses the same API calls as the official client
      # https://github.com/Sude-/lgogdownloader
      lgogdownloader-gui

      # A sensible wine/proton wrapper for games
      # https://github.com/bottlesdevs/Bottles
      bottles

      # Use winetricks in proton
      # https://github.com/Matoking/protontricks
      protontricks

      # Simple Wine and Proton-based compatibility tools manager
      # https://github.com/Vysp3r/ProtonPlus
      protonplus

      # Run any Windows program with Proton. `proton-call -r foo.exe`
      # https://github.com/gtors/proton-caller
      proton-caller
    ];
  };
}
