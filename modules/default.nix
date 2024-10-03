{ outputs, pkgs, ... }:
{
  ## These are the defaults I want on every machine:
  imports =
  [
    ./zsh.nix
    ./tui.nix
    ./nvim
    ./ssh.nix
  ];

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
  };

  environment.systemPackages = with pkgs; [
    # 7-Zip
    p7zip

    # SSH File System
    sshfs

    # Rust grep use `rg`
    repgrep
    ripgrep
    ripgrep-all

    # Rage - Rust implementation of age
    # https://github.com/str4d/rage
    rage

    # eza - Modern, maintained replacement for ls
    # https://github.com/eza-community/eza
    unstable.eza

    # Zoxide - A fast cd command that learns your habits
    # https://github.com/ajeetdsouza/zoxide
    # https://www.youtube.com/watch?v=aghxkpyRVDY
    unstable.zoxide

    # Starship - A minimal, blazing fast, and extremely customizable prompt for any shell
    # https://starship.rs/
    unstable.starship

    # fzf - Command-line fuzzy finder written in Go
    # https://github.com/junegunn/fzf
    fzf

    # zellij - Terminal Multiplexor written in Rust
    zellij

    # Lemonade - Remote utility tool that to copy, paste and open browsers over TCP
    # https://github.com/lemonade-command/lemonade/
    lemonade
  ];

  # TODO: Consider using this:
  # boot.initrd.network.ssh.authorizedKeyFiles is a new option in the initrd ssh daemon module,
  # for adding authorized keys via list of files.

  # Removes old Perl scripts (fixed in master branch only, unsure how to obtain that)
  #boot.initrd.systemd.enable = true;
  #system.etc.overlay.enable = true;
  #systemd.sysusers.enable = true;

  # nixpkgs allow unfree with unstable overlay.
  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
      #outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };


  nix = {
    settings = {
      # Enable flakes.
      experimental-features = [ "nix-command" "flakes" ];
      # Uses hard links to remove duplicates in the nix store
      auto-optimise-store = true;
    };
  };

  # Deletes temp files on boot.
  boot.tmp.useTmpfs = true;

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
    # Console typo fixer
    thefuck.enable = true;
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

  # Policy Kit, necessary for some things like hyperland, 1Pass, etc
  security.polkit.enable = true;

  # Services.
  services = {
    locate.enable = true;
    # Use Avahi to make this computer discoverable and
    # to discover other computers.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      domainName = "wakenet";
    };
  };
}
