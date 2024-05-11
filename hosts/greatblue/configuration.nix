{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
  [
    <nixos-hardware/gpd/win-max-2/2023>
    ./hardware-configuration.nix
    #<nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernal Params.
  boot.kernelParams = [ "drm_kms_helper.poll=N" "usbcore.autosuspend=-1" ];

  # Deletes temp files on boot.
  boot.tmp.useTmpfs = true;
  nix.gc.automatic = true;

  networking.hostName = "GreatBlue"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the Gnome Desktop Environment using Wayland.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
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

  # Configure keymap in X11.
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
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

  users.defaultUserShell = pkgs.zsh;

  users.users.kent = {
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" ];
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
      _1password
      _1password-gui
      git-credential-1password

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
    ];
  };

  # Not sure which package this is for, but I think it might be obsidian
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Enable keyboard access
  hardware.keyboard.qmk.enable = true;

  # Turn on zsh
  programs.zsh = {
    enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l = "lsd -al";
      cd = "z";
    };
    shellInit = ''
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
      #eval "$(atuin init zsh)"
    '';
  };

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

  # Allows VSCode to install plugins like normal.
  programs.nix-ld.enable = true;

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
#     config = [
#       { init = { defaultBranch = "main"; }; }
#       { user = {
#         name = "Kent Hambrock";
#         email = "Kent.Hambrock@gmail.com";
#         signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
#       };}
#       { gpg = { format = "ssh"; }; }
#       { commit = { gpgsign = true; }; }
#     ];
  };

  # Console typo fixer
  programs.thefuck.enable = true;

  # Keep the Nix package store optimised
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

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
    NIXOS_OZONE_WL = "1";
  };

  # List packages ilibsForQt5.kdenlivenstalled in system profile.
  environment.systemPackages = with pkgs; [
    xorg.xcbutil

    # Drivers to support docks with HDMI ports
    displaylink

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
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
    # Makes ArcMenu work on Wayland
    unstable.xdg-utils
    xdg-user-dirs
    gnome-menus # <- Needed for ArcMenu, but doesn't seem to work
    # Makes QT/KDE apps look like Gnome apps
    adwaita-qt

    polkit_gnome

    # Allows me to avoid retyping my default KDE wallet password while I'm logged in.
    #libsForQt5.kwallet-pam

    # Allows me to use U2F/FIDO2 USB keys
    pam_u2f

    # utils
    usbutils
    android-tools

    # 7-zip
    p7zip

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

    # Rust grep use `rg`
    repgrep
    ripgrep
    ripgrep-all

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

    # lsd - The next gen ls command
    # https://github.com/lsd-rs/lsd
    unstable.lsd

    # Zoxide - A fast cd command that learns your habits
    # https://github.com/ajeetdsouza/zoxide
    # https://www.youtube.com/watch?v=aghxkpyRVDY
    unstable.zoxide

    # fzf - Command-line fuzzy finder written in Go
    # https://github.com/junegunn/fzf
    fzf

    # Terminal file managers
    # https://github.com/antonmedv/walk
    walk
    # https://github.com/dzfrias/projectable
    projectable
    # https://github.com/GiorgosXou/TUIFIManager
    tuifimanager
    # Yazi - Blazing fast terminal file manager written in Rust, based on async I/O
    # https://github.com/sxyazi/yazi
    yazi
    # xplr - A hackable, minimal, fast TUI file explorer
    # https://xplr.dev/
    xplr
    # Terminal UI for Systemd Logs and Status
    # https://crates.io/crates/systemctl-tui
    systemctl-tui

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

    # Nerdfonts - Iconic font aggregator, collection, and patcher
    # https://www.nerdfonts.com/
    unstable.nerdfonts

    # Starship - A minimal, blazing fast, and extremely customizable prompt for any shell
    # https://starship.rs/
    unstable.starship

    # notcurses - blingful character graphics/TUI library. definitely not curses.
    # https://github.com/dankamongmen/notcurses
    notcurses

    ## Neovim
    unstable.neovim
    ## Find more plugins here:
    ## https://search.nixos.org/packages?channel=unstable&show=vimPlugins.edge&from=0&size=50&sort=relevance&type=packages&query=vimPlugins.
    # A GTK UI for Neovim
    unstable.neovim-gtk
    # Plugin for zellij
    unstable.vimPlugins.zellij-nvim
    # Nodejs extension host for vim & neovim,
    # load extensions like VSCode and host language servers.
    unstable.vimPlugins.coc-nvim
    # Plugin for adding Rust Language Server
    unstable.vimPlugins.coc-rls
    # Plugin for adding Rust analyzer support
    unstable.vimPlugins.coc-rust-analyzer
    # Plugin for adding Bash Language Server
    unstable.vimPlugins.coc-sh
    # Plugin for adding fzf fuzzy searching
    unstable.vimPlugins.coc-fzf
    # Plugin for adding Git support
    unstable.vimPlugins.coc-git
    # Plugin for adding YAML support
    unstable.vimPlugins.coc-yaml
    # Plugin for adding TOML support
    unstable.vimPlugins.coc-toml
    # Plugin for adding LaTeX and markdown support
    unstable.vimPlugins.coc-ltex
    # Plugin for adding JSON support
    unstable.vimPlugins.coc-json
    # Plugin for adding HTML support
    unstable.vimPlugins.coc-html
    # Plugin for adding Common lists
    # https://github.com/neoclide/coc-lists#readme
    unstable.vimPlugins.coc-lists
    # Plugin for adding Tab9 AI autocomplete
    unstable.vimPlugins.coc-tabnine
    # Plugin for adding a folders pane
    unstable.vimPlugins.coc-explorer
    # Plugin for adding `prettier` support
    unstable.vimPlugins.coc-prettier
    # A fast finder system for neovim
    # https://github.com/camspiers/snap/
    unstable.vimPlugins.snap
    # Clean & Elegant Color Scheme inspired by Atom One and Material
    unstable.vimPlugins.edge
    # Delicious diagnostic debugging in Neovim
    unstable.vimPlugins.wtf-nvim
    # IDE for Neovim
    unstable.lunarvim

    # hyfetch - neofetch with pride flags
    hyfetch

    # mpv - General-purpose media player, fork of MPlayer and mplayer2
    # https://mpv.io/
    mpv
    # mpvc - A mpc-like control interface for mpv
    # https://github.com/lwilletts/mpvc
    mpvc

    # Lazycli - A tool to static turn CLI commands into TUIs
    # https://github.com/jesseduffield/lazycli
    lazycli

    # Oxker - A simple tui to view & control docker containers
    # https://github.com/mrjackwills/oxker
    oxker

    # FastSSH is a TUI that allows you to quickly connect to your services by navigating through your SSH config.
    # https://github.com/julien-r44/fast-ssh
    fast-ssh

    # GitUI provides you with the comfort of a git GUI but right in your terminal
    # https://github.com/extrawurst/gitui
    unstable.gitui

    # Stress-Terminal UI, s-tui, monitors CPU temperature, frequency, power and utilization in a graphical way from the terminal.
    # https://amanusk.github.io/s-tui/
    unstable.s-tui

    # wiki-tui - A simple and easy to use Wikipedia Text User Interface
    # https://github.com/builditluc/wiki-tui
    wiki-tui

    # yt-dlp - Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    # https://github.com/yt-dlp/yt-dlp/
    yt-dlp

    # termusic - Terminal Music and Podcast Player written in Rust
    # https://github.com/tramhao/termusic
    unstable.termusic
  ];

  # Enable Atuin
  # Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
  # https://github.com/atuinsh/atuin
  services.atuin = {
    enable = true;
  };

  # Enale direnv
  programs.direnv.enable = true;

  # Partition manager
  programs.partition-manager.enable = true;

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

  fonts.packages = with pkgs; [
    # Better emojis
    twemoji-color-font

    # Comic Sans like fonts for making memes
    comic-mono
    comic-neue

    # Just some nice fonts
    source-sans
  ];

  # Security
  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    authFile = "/etc/u2f_mappings";
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    su.u2fAuth = true;
    gdm-launch-environment.u2fAuth = true;
    gdm-password.u2fAuth = true;
    polkit-1.u2fAuth = true;
    kde.u2fAuth = true;
  };
  security.polkit.enable = true;

  # Services
  services.locate.enable = true;
  services.flatpak.enable = true;

  # Use Avahi to make this computer discoverable and to discover other computers.
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  systemd.user.services.kent-autostart = {
    description = "Updates packages";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = ''
      nix-channel --update
      nixos-rebuild --switch
      nix-collect-garbage --delete-older-than 7d
    '';
    wantedBy = [ "multi-user.target" ]; # starts after login
  };

  # Disable the fingerprint reader since it causes resume from sleep to fail.
  # But this method doesn't seem to work
  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0"
  '';

  # Firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;
  # For helping find local samba shares.
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  # Hardware.
  hardware.bluetooth.enable = true;


#   virtualisation.vmVariant = {
#     # following configuration is added only when building VM with build-vm
#     virtualisation.cores = 4;
#   };

  system.stateVersion = "23.11";
}
