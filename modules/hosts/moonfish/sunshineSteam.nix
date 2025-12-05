{ lib, config, pkgs, ...}:
let
  cfg = config.sunshineSteam;
in
{
  options.sunshineSteam = with lib; {
    enable = mkEnableOption "Enable Steam and Sunshine, using autologin with gamescope and greetd.";

    quietBoot = mkEnableOption "Enable kernel params and plymouth to make the boot as quiet as possible.";
  };

  config = lib.mkIf cfg.enable {
    boot = lib.mkIf cfg.quietBoot {
      kernelParams = [ "quiet" "splash" "console=/dev/null" ];
      plymouth.enable = true;
    };

    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode.enable = true;
      steam = {
        enable = true;

        package = pkgs.steam.override {
          extraPkgs = pkgs': with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
            # Add other libraries as needed
          ];
        };

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
    };

    # Enable Xbox One controllers
    hardware.xone.enable = true;

    environment.systemPackages = with pkgs; [
      # Steam container with FHS support
      steam-run

      # Cli interface for Steam
      steamcmd

      # Game launcher with access to Steam, GOG, Epic, and Humble Bundle
      # https://github.com/lutris/lutris
      lutris

      # Game launcher with access to Epic, GOG, and Amazon Games
      # https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher
      heroic

      # Unofficial GOG downloader that uses the same API calls as the official client
      # https://github.com/Sude-/lgogdownloader
      # Using compromised `qtwebengine-5.15.19`
      # Reanable when they update to qt6
      # lgogdownloader-gui

      # A sensible wine/proton wrapper for games
      # https://github.com/bottlesdevs/Bottles
      bottles

      # Use winetricks in proton
      # https://github.com/Matoking/protontricks
      protontricks

      # Simple Wine and Proton-based compatibility tools manager
      # https://github.com/Vysp3r/ProtonPlus
      protonplus

      # Used to allow gamescope to use HDR
      gamescope-wsi
    ];

    users.users.entertainment = {
      isNormalUser = true;
      description = "Entertainment";
      extraGroups = [ "networkmanager" "storage" "input" "gamemode" ];
    };
    # Gamescope Auto Boot from TTY (example)
    services.xserver.enable = false; # Assuming no other Xserver needed
    services.getty.autologinUser = "entertainment";

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.gamescope}/bin/gamescope -W 1920 -H 1080 -f -e --xwayland-count 2 --hdr-enabled --hdr-itm-enabled -- steam -pipewire-dmabuf -gamepadui -steamdeck -steamos3 > /dev/null 2>&1";
          user = "entertainment";
        };
      };
    };
    services.sunshine = {
      enable = true;
      autoStart = true;
      # Needed for Wayland use, disable for x11
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
