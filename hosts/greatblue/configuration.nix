{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Trying to prevent the fingerprint reader from blocking resume from suspend-to-ram
  boot.kernelParams = [ "drm_kms_helper.poll=N" "usbcore.autosuspend=-1" ];

  networking.hostName = "GreatBlue";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the Gnome Desktop Environment using Wayland.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    videoDrivers = [ "displaylink" "modesetting" ];
    desktopManager.gnome.enable = true;
  };
  services.xserver.dpi = 300;

  # Style the KDE apps in Gnome drip.
  qt = {
    # null or one of "adwaita", "adwaita-dark", "adwaita-highcontrast", "adwaita-highcontrastinverse",
    # "bb10bright", "bb10dark", "breeze", "cde", "cleanlooks", "gtk2", "kvantum", "motif", "plastique"
    style = "adwaita-dark";
    platformTheme = "gnome";
    enable = true;
  };

  # Exclude certain Gnome packages.
  environment.gnome.excludePackages = (with pkgs; [
    # for packages that are pkgs.***
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    # for packages that are pkgs.gnome.***
    epiphany # web browser
    geary # email reader
    evince # document viewer
  ]);

  services.gnome.gnome-browser-connector.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser pkgs.cups-dymo ];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.kent = {
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q kent" ];
    packages = with pkgs; [
      # Gnome specific stuffs
      gnome.gnome-tweaks

      # Rofi - Window switcher, run dialog and dmenu replacement for Wayland
      # https://github.com/lbonn/rofi
      rofi-wayland
      # Tiny dynamic menu for Wayland
      # https://github.com/philj56/tofi
      tofi

      # Clipboard manager
      copyq

      # Tailscale VPN
      #tailscale
      #ktailctl

      # TTS
      piper-tts
      sox

      # Steam thing
      steam-run

      # Office
      #libreoffice-qt

      # Internet browsers
      firefox
      google-chrome

      # IDEs
      unstable.vscode-fhs
      libsForQt5.kate

      # Language servers
      nodePackages.bash-language-server
      nixd

      # Generate Nix packages from URLs
      # https://github.com/nix-community/nix-init
      nix-init

      # Chat apps
      discord
      element-desktop
      telegram-desktop

      # Music
      tidal-hifi

      # Password Management
      unstable._1password
      unstable._1password-gui

      # Image editing
      gimp-with-plugins
      darktable
      rawtherapee
      exiftool
      inkscape

      # Video editing
      # davinci-resolve
      # davinci-resolve-studio
      #unstable.kdePackages.kdenlive # <- Won't start with Gnome on NixOS 23.11
      libsForQt5.kdenlive
      # Vector animation tool that works with kdenlive
      glaxnimate
      vlc

      # Keyboard firmware
      via
      vial

      # Games stuff
      lutris
      heroic # Epic and GOG games
      bottles # A sensible Wine wrapper for games

      # Atuin - Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
      # https://atuin.sh/
      unstable.atuin

      # Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win
      # https://github.com/hhd-dev/hhd
      unstable.handheld-daemon

      # Note taking app
      obsidian

      # Just - A handy way to save and run project-specific commands
      # https://just.systems/man/en/
      just
      
      # Collection of image builders
      # https://github.com/nix-community/nixos-generators
      nixos-generators
      
      sshfs
      android-studio
      soundwireserver

      # OpenSCAD
      unstable.openscad-unstable
    ];
  };

  # Not sure which package this is for, but I think it might be obsidian
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Enable keyboard access
  hardware.keyboard.qmk.enable = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play.
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server.
    # Compatibility option some games may need to run. To use,
    # change steam Launch Options on per game basis to `gamescope %command%`
    gamescopeSession.enable = true;
  };

  # Better performance when gaming. To use,
  # change steam Launch Options on per game basis to `gamemoderun %command%`
  programs.gamemode.enable = true;

  # Make 1 Password work correctly
  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "kent" ];
  };

  programs.git = {
    enable = true;
    config = [
      { init = { defaultBranch = "main"; }; }
      { user = {
        name = "Kent Hambrock";
        email = "Kent.Hambrock@gmail.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
      };}
      { gpg = { format = "ssh"; }; }
      { commit = { gpgsign = true; }; }
      { "gpg \"ssh\"" = { program = "${config.programs._1password.package}/share/1password/op-ssh-sign"; }; }
    ];
  };

  # Environment variables
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
    # Session var to ensure chrome/electron apps are
    # rendered corectly when using Wayland
    #NIXOS_OZONE_WL = "1";

    # Makes SSH work with 1Password
    SSH_AUTH_SOCK="~/.1password/agent.sock";
  };

  environment.systemPackages = with pkgs; [
    xorg.xcbutil

    # Drivers to support docks with HDMI ports
    displaylink

    # Cups-filers for printing PNG to Dymo XL4
    cups-filters

    # To disable middle mouse click paste
    # https://askubuntu.com/questions/4507/how-do-i-disable-middle-mouse-button-click-paste/1387263#1387263
    #xbindkeys
    #xsel
    #xdotool

    # Dolphin refused to handle zips without this
    #libsForQt5.ark

    # Wayland things
    # Sirula - Simple app launcher for wayland written in rust
    # https://github.com/DorianRudolph/sirula
    # sirula <- Waiting on PR: https://github.com/NixOS/nixpkgs/pull/281963

    # Gnome Extensions
    gnomeExtensions.dash-to-panel
    #gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
    gnome-menus

    unstable.polkit_gnome

    # Rust based teamviewer alternative
    rustdesk

    # Allows me to use U2F/FIDO2 USB keys
    pam_u2f

    # utils
    usbutils
    android-tools

    # Nix packager
    nix-init

    # Allows me to mount samba drives
    cifs-utils

    # Git
    git

    # aspell
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    # commandline clipboad manipulation
    xclip

    # Audio and video format converter
    unstable.ffmpeg_7-full

    # Bash floating point maths
    bc

    # Alacritty -
    # https://github.com/alacritty/alacritty
    unstable.alacritty
    unstable.alacritty-theme

    # Zellij - A terminal workspace with batteries included
    # https://github.com/zellij-org/zellij
    # https://www.youtube.com/watch?v=gtjPeTCkm-8
    zellij

    # Typing tester TUI
    # https://github.com/jrnxf/thokr
    thokr

    # GPD Specific Tools:
    # RyzenAdj for controlling many RyzenCPU/APU/GPU power settings
    # https://github.com/FlyGoat/RyzenAdj
    unstable.ryzenadj

    # Use Firefox's Readability API to extract useful
    # text from webpages and display them in the terminal
    # https://gitlab.com/gardenappl/readability-cli
    readability-cli

    ## Neovim
    # A GTK UI for Neovim
    unstable.neovim-gtk
    # Plugin for zellij
    # IDE for Neovim
    unstable.lunarvim

    # FastSSH is a TUI that allows you to quickly connect to your services by navigating through your SSH config.
    # https://github.com/julien-r44/fast-ssh
    fast-ssh

    # wiki-tui - A simple and easy to use Wikipedia Text User Interface
    # https://github.com/builditluc/wiki-tui
    wiki-tui

    # termusic - Terminal Music and Podcast Player written in Rust
    # https://github.com/tramhao/termusic
    unstable.termusic

    # Makes the 8BitDo controller work
    xboxdrv

    # Tools for testing Vulkan driver compatibility
    vulkan-tools
  ];
  
  # Udev rules to start or stop systemd service when controller is connected or disconnected
  services.udev.extraRules = ''
    # May vary depending on your controller model, find product id using 'lsusb'
    SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="3106", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl start 8bitdo-ultimate-xinput@2dc8:3106"
    # This device (2dc8:3016) is "connected" when the above device disconnects
    SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="3016", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl stop 8bitdo-ultimate-xinput@2dc8:3106"

    ACTION=="add", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0"
  '';

  # Systemd service which starts xboxdrv in xbox360 mode
  systemd.services."8bitdo-ultimate-xinput@" = {
    unitConfig.Description = "8BitDo Ultimate Controller XInput mode xboxdrv daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.xboxdrv}/bin/xboxdrv --mimic-xpad --silent --type xbox360 --device-by-id %I --force-feedback";
    };
  };

  # Enable Atuin
  # Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
  # https://github.com/atuinsh/atuin
  services.atuin = {
    enable = true;
  };

  # Enale direnv
  programs.direnv.enable = true;

  # Samba
  fileSystems = {
    "/mnt/Share_Public" = {
      device = "//192.168.0.46/Share_Public";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/Share_Family" = {
      device = "//192.168.0.46/Share_Family";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/Share_Friends" = {
      device = "//192.168.0.46/Share_Friends";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/Personal_Kent" = {
      device = "//192.168.0.46/Personal_Kent";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/hdd1" = {
      device = "//192.168.0.23/hdd1";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials2,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/hdd2" = {
      device = "//192.168.0.23/hdd2";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials2,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
  };

  # Security
  security.pam = {
    u2f = {
      enable = true;
      control = "sufficient";
      authFile = "/etc/u2f_mappings";
      appId = "pam://NixOS";
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      su.u2fAuth = true;
      gdm-launch-environment.u2fAuth = true;
      gdm-password.u2fAuth = true;
      polkit-1.u2fAuth = true;
      #kde.u2fAuth = true;
    };
  };
  security.polkit.enable = true;

  # Services
  services.flatpak.enable = true;

  systemd.user.services.kent-autostart = {
    description = "Updates packages";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = ''
      #!/bin/sh
      nix-collect-garbage --delete-older-than 7d
    '';
    wantedBy = [ "multi-user.target" ]; # starts after login
  };

  # Disable the fingerprint reader since it causes resume from sleep to fail.
  # But this method doesn't seem to work
  # services.udev.extraRules = ''
  #  ACTION=="add", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0"
  # '';

  # Firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;
  # For helping find local samba shares.
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  # Hardware.
  hardware.bluetooth.enable = true;

  # Enable binfmt emulation of aarch64-linux.
  # Supports building for phone architectures.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "23.11";
}
