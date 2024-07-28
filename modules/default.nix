{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  ## These are the defaults I want on every machine:

  imports =
  [
    ./zsh.nix
    ./tui.nix
    ./nvim.nix
  ];

  environment.systemPackages = with pkgs; [
    # Rust based teamviewer
    rustdesk-flutter

    # 7-zip
    p7zip

    # Git
    git

    # Rust grep use `rg`
    repgrep
    ripgrep
    ripgrep-all

    # lsd - The next gen ls command
    # https://github.com/lsd-rs/lsd
    unstable.lsd

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

  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Deletes temp files on boot.
  boot.tmp.useTmpfs = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Keep the Nix package store optimised.
  nix.settings.auto-optimise-store = true;

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

  # Allows installing unpackaged binaries
  programs.nix-ld = {
    enable = true;
    package = pkgs.nil;
  };

  # Console typo fixer.
  programs.thefuck.enable = true;

  # Services.
  services.locate.enable = true;

  # Use Avahi to make this computer discoverable and to discover other computers.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    domainName = "local";
  };

  fonts.packages = with pkgs; [
    # Better emojis
    twemoji-color-font

    # Nerdfonts
    unstable.nerdfonts
  ];
}
