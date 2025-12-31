{ lib, config, pkgs, ... }:
let
  gaming = config.gui.gaming;
  isGamingHost = config.modules.systemDetails.features.gaming;
in
{
  options.gui.gaming = {
    enable = lib.mkEnableOption "Enable Steam, GOG, etc." // {
      default = isGamingHost;
    };
  };

  config = lib.mkIf gaming.enable {
    programs = {
      # Enable Steam
      steam = {
        enable = true;
        # Compatibility option some games may need to run. To use,
        # change steam Launch Options on per game basis to `gamescope %command%`
        gamescopeSession.enable = true;

        # A simple wrapper for running Winetricks commands for Proton-enabled games.
        protontricks.enable = true;

        # Proton-GE is an open source experimentally patched version of proton
        # Sometimes necessary for newer games.
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
      # Better performance when gaming. To use,
      # change steam Launch Options on per game basis to `gamemoderun %command%`
      gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Steam container
      steam-run

      lutris
      heroic       # Epic and GOG games
      bottles      # A sensible Wine wrapper for games
      protontricks # Use winetricks in proton
      protonplus   # Simple Wine and Proton-based compatibility tools manager

      # For remoting into Sunshine hosts
      moonlight-qt

      # Joystick/gamepad diagnostic tools
      linuxConsoleTools
      jstest-gtk
    ];

    # Enable xbox one acccessories
    hardware = {
      xone.enable = true;
      uinput.enable = true;
    };

    # udev rules for recognizing more 3rd party game controllers
    services = {
      udev = {
        packages = with pkgs; [
          game-devices-udev-rules
          steam-devices-udev-rules
        ];
      };
    };

    # A game streaming server used with the moonlight app on Android.
    # On the moonlight client manually add the server as `<server IP>:47989`
    services.sunshine = {
      enable = true;
      # If autoStart is set to true, server will run on system login
      # If autoStart is set to false you need to start the server with the command `sunshine`
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
