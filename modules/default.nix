{ inputs, outputs, pkgs, lib, systemDetails, ... }:
{
  ## These are the defaults I want on every machine:
  imports =
  [
    ./common
    ./gui
    ./servers
  ];

  options.modules.systemDetails = with lib; {
    # systemDetails is found and can be edited in each host's configuration in flake.nix
    # It can be overriden in a given host's configuration, but that's not the intended usecase.
    #
    # hostName     = (string of) hostname or home-manager configuration
    # hostType     = (one of) "laptop" "desktop" "server" "android" "kiosk"
    # display      = (one of) "wayland" "x11" "cli"
    # features     = (none, one, or more of) "printers" "installer" "einkBW" "einkColor"
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

    # Features [ "printers" "installer" "eink" "einkColor" ]
    # (`installer` and `printer` options aren't included in home-manager)
    features = {
      printers = mkOption {
        type = types.bool;
        default = (builtins.match "printers" systemDetails.features != null);
        description = "True if host should have printer access.";
      };
      installer = mkOption {
        type = types.bool;
        default = (builtins.match "installer" systemDetails.features != null);
        description = "True if derivation needs .";
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
    ];

    # TODO: Consider using this:
    # boot.initrd.network.ssh.authorizedKeyFiles is a new option in the initrd ssh daemon module,
    # for adding authorized keys via list of files.

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
        # Uses hard links to remove duplicates in the nix store
        auto-optimise-store = true;
      };
    };

    # Deletes temp files on boot.
    boot.tmp.useTmpfs = lib.mkDefault true;

    # Set your time zone.
    time.timeZone = "America/New_York";

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

    # Services.
    services = {
      locate.enable = true;
      # Automount USB drives
      gvfs.enable = true;
      # Use Avahi to make this computer discoverable and
      # to discover other computers.
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        domainName = "wakenet";
      };
      # Enable SMART error monitoring on NixOS machines
      smartd.enable = true;
    };
  };
}
