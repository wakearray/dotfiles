{ outputs, pkgs, lib, systemDetails, ... }:
{
  ## These are the defaults I want on every machine:
  imports =
  [
    ./common
    ./gui
  ];

  options.modules.systemDetails = with lib; {
    # systemDetails is found and can be edited in each host's configuration in flake.nix
    # It can be overriden in a given host's configuration, but that's not the intended usecase.
    #
    # hostName     = (string of) hostname or home-manager configuration
    # hostType     = (one of) "laptop" "desktop" "server" "android" "kiosk"
    # display      = (one of) "wayland" "x11" "cli"
    # features     = (none, one, or more of) "printers" "installer"
    #                "gaming" "minimal" "developer" "gaming" "eink" "einkColor"
    # architecture = (one of) "x86_64-linux" "aarch64-linux"

    # Hostname
    hostName = mkOption {
      type = types.str;
      default = systemDetails.hostName;
      description = "Set to the host's hostname to make accessing the hostname in scripts easier.";
    };

    # Host Type: [ "laptop" "desktop" "server" "android" "kiosk" ]
    # Android can't use full NixOS on any of my devices, so isn't here
    isLaptop = mkOption {
      type = types.bool;
      default = (builtins.match "laptop" systemDetails.hostType != null);
      description = "True if host is a laptop (or laptop like portable).";
    };
    isDesktop = mkOption {
      type = types.bool;
      default = (builtins.match "desktop" systemDetails.hostType != null);
      description = "True if host is a desktop.";
    };
    isServer = mkOption {
      type = types.bool;
      default = (builtins.match "server" systemDetails.hostType != null);
      description = "True if host is a server.";
    };
    isKiosk = mkOption {
      type = types.bool;
      default = (builtins.match "kiosk" systemDetails.hostType != null);
      description = "True if host is intended to be used like a kiosk.";
    };

    # Display [ "wayland" "x11" "cli" ]
    display = {
      wayland = mkOption {
        type = types.bool;
        default = (builtins.match "wayland" systemDetails.display != null);
        description = "True if device uses wayland.";
      };
      x11 = mkOption {
        type = types.bool;
        default = (builtins.match "x11" systemDetails.display != null);
        description = "True if device uses x11.";
      };
      cli = mkOption {
        type = types.bool;
        default = (builtins.match "cli" systemDetails.display != null);
        description = "True if host does not use x11 or wayland.";
      };
    };

    # Features [ "printers" "installer" "minimal" "developer" "gaming" "eink" "einkColor" ]
    # (`installer` and `printer` options aren't included in home-manager)
    features = {
      installer = mkOption {
        type = types.bool;
        default = (builtins.match ".*installer.*" systemDetails.features != null);
        description = "True if derivation needs `nixos-instal` tools.";
      };
      minimal = mkOption {
        type = types.bool;
        default = (builtins.match ".*minimal.*" systemDetails.features != null);
        description = "True if derivation needs a minimal build. Mostly for low spec VPS like Hetzner and Oracle.";
      };
      developer = mkOption {
        type = types.bool;
        default = (builtins.match ".*developer.*" systemDetails.features != null);
        description = "True if derivation needs developer tools. A SteamDeck probably doesn't, for instance.";
      };
      gaming = mkOption {
        type = types.bool;
        default = (builtins.match ".*gaming.*" systemDetails.features != null);
        description = "True if derivation needs gaming apps/settings.";
      };
    };

    # Architecture
    architecture = {
      text = mkOption {
        type = types.str;
        default = systemDetails.architecture;
        description = "The text, as a string, of the current host's architecture.";
      };
      isx86_64 = mkOption {
        type = types.bool;
        default = (builtins.match "x86_64-linux" systemDetails.architecture != null);
        description = "True if host is using an x86_64 CPU.";
      };
      isAarch64 = mkOption {
        type = types.bool;
        default = (builtins.match "aarch64-linux" systemDetails.architecture != null);
        description = "True if host is using an aarch64 SOC.";
      };
    };
  };
  config = {
    # Environment variables
    environment.sessionVariables = {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";

      # Not officially in the specification
      XDG_BIN_HOME    = "$HOME/.local/bin";
      PATH = [ "$HOME/.local/bin" ];
    };

    environment.systemPackages = with pkgs; [
      # 7-Zip
      _7zz

      # eza - Modern, maintained replacement for ls
      # https://github.com/eza-community/eza
      eza

      # Zoxide - A fast cd command that learns your habits
      # https://github.com/ajeetdsouza/zoxide
      # https://www.youtube.com/watch?v=aghxkpyRVDY
      zoxide

      # Starship - A minimal, blazing fast, and extremely customizable prompt for any shell
      # https://starship.rs/
      starship

      # fzf - Command-line fuzzy finder written in Go
      # https://github.com/junegunn/fzf
      fzf

      # Lemonade - Remote utility tool that to copy, paste and open browsers over TCP
      # https://github.com/lemonade-command/lemonade/
      lemonade

      # https://www.gnu.org/software/wget/
      wget

      # ImageMagick - Command line software for manipulating images
      # https://imagemagick.org/
      imagemagick

      # Fast duplicate file finder written in rust
      ddh
    ];

    # Add the userdata usergroup
    users.groups.userdata = {};

    # Enable userborn declarative user management
    services.userborn.enable = true;

    # nixpkgs allow unfree with unstable overlay.
    nixpkgs = {
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.stable-packages

        # You can also add overlays exported from other flakes:
        # neovim-nightly-overlay.overlays.default
      ];
      config = {
        allowUnfree = true;
      };
    };

    nix = {
      package = pkgs.lixPackageSets.latest.lix;
      settings = {
        # Enable flakes.
        experimental-features = [ "nix-command" "flakes" ];

        # download-buffer-size is unavailable in lix
        # download-buffer-size = 524288000; # 500 MiB

        # Uses hard links to remove duplicates in the nix store
        auto-optimise-store = true;

        substituters = [
          "http://192.168.0.46:8501"  # Use https:// if behind reverse proxy
          "https://cache.nixos.org"
          # ... other substituters
        ];

        trusted-public-keys = [
          "Delaware:Ec+pe9fhw0x2ADj3DNBZ06d0xVgmn5shUNbEP0d2k+Q="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          # ... other keys
        ];
      };
    };

    # Deletes temp files on boot.
    boot.tmp.useTmpfs = lib.mkDefault true;

    # Set your time zone.
    time.timeZone = lib.mkDefault "America/New_York";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
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
    };

    programs = {
      # Allows installing unpackaged binaries
      nix-ld.enable = true;
      # Installs git as a system program
      git.enable = true;
      # Enable direnv
      direnv.enable = true;
      # Not Another Command Line Nix Helper
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 3";
        };
      };
    };

    # RAM compression
    zramSwap = {
      enable = true;
      # Change this on a per machine basis
      memoryPercent = lib.mkDefault 50;
    };

    # Services.
    services = {
      locate.enable = true;
      # Automount USB drives
      gvfs.enable = lib.mkDefault true;
      # Use Avahi to make this computer discoverable and
      # to discover other computers.
      avahi = {
        enable = lib.mkDefault true;
        nssmdns4 = true;
        openFirewall = true;
        domainName = "wakenet";
        publish = {
          enable = true;
          userServices = true;
        };
      };
      # Enable SMART error monitoring on NixOS machines
      smartd.enable = lib.mkDefault true;
    };
  };
}
