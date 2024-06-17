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
  ];

  environment.systemPackages = with pkgs; [

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
  nix.gc.automatic = true;

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

  # Console typo fixer.
  programs.thefuck.enable = true;

  # Services.
  services.locate.enable = true;

  # Use Avahi to make this computer discoverable and to discover other computers.
#   services.avahi = {
#     enable = true;
#     nssmdns4 = true;
#     openFirewall = true;
#     domainName = "local";
#   };

  fonts.packages = with pkgs; [
    # Better emojis
    twemoji-color-font

    # Comic Sans like fonts for making memes
    comic-mono
    comic-neue

    # Just some nice fonts
    source-sans

    # Nerdfonts
    unstable.nerdfonts
  ];
}
