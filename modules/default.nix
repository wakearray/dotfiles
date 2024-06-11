{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  ## These are the defaults I want on every machine:

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

  # Set zsh as the default user shell.
  users.defaultUserShell = pkgs.zsh;

  # Turn on zsh.
  programs.zsh = {
    enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      # use lsd instead of ls.
      l = "lsd -al";
      # use zoxide instead of cd.
      cd = "z";
    };
    shellInit = ''
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
      #eval "$(atuin init zsh)"
    '';
  };

  # Console typo fixer.
  programs.thefuck.enable = true;

  # Services.
  services.locate.enable = true;

  # Use Avahi to make this computer discoverable and to discover other computers.
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    domainName = "local";
  };
}
