{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  gaming = gui.gaming;
in
{
  options.gui.gaming = {
    enable = lib.mkEnableOption "Enable Steam, GOG, etc.";
  };
  config = lib.mkIf (gui.enable && gaming.enable) {
    programs = {
      # Enable Steam
      steam = {
        enable = true;
        # Open ports in the firewall for Steam Remote Play.
        remotePlay.openFirewall = true;
        # Open ports in the firewall for Source Dedicated Server.
        dedicatedServer.openFirewall = true;
        # Compatibility option some games may need to run. To use,
        # change steam Launch Options on per game basis to `gamescope %command%`
        gamescopeSession.enable = true;
      };
      # Better performance when gaming. To use,
      # change steam Launch Options on per game basis to `gamemoderun %command%`
      gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
        # Steam container
        steam-run

        # Games stuff
        lutris
        heroic # Epic and GOG games
        bottles # A sensible Wine wrapper for games
    ];
  };
}
