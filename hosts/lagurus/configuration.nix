# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Lagurus"; # Previously "cat-projector"
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Gnome desktop.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kent = {
    isNormalUser = true;
    description = "kent";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q kent" ];
    packages = with pkgs; [
      # GUI Text Editor
      libsForQt5.kate

      # Web Browsers
      google-chrome
    ];
  };

  # Autologin as Kent
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kent";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Youtube Downloader
    yt-dlp
    youtube-tui

    # Video Player
    vlc
    mpv

    # Terminal UI for Systemd Logs and Status
    # https://crates.io/crates/systemctl-tui
    systemctl-tui

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

    # Nerdfonts - Iconic font aggregator, collection, and patcher
    # https://www.nerdfonts.com/
    unstable.nerdfonts

    # Starship - A minimal, blazing fast, and extremely customizable prompt for any shell
    # https://starship.rs/
    unstable.starship

    # notcurses - blingful character graphics/TUI library. definitely not curses.
    # https://github.com/dankamongmen/notcurses
    notcurses
  ];

#   systemd.user.services."catvideo" = {
#     enable = true;
#     description = "Play string video for cat";
#     serviceConfig = {
#       Type = "simple";
#       ExecStart = "vlc -L -f /home/kent/Desktop/string_video.webm";
#       ExecStop = "pkill cat-video";
#       Restart = "on-failure";
#     };
#     wantedBy = [ "default.target" ];
#   };

  services.xserver.displayManager.setupCommands = "vlc -L -f /home/kent/Desktop/string_video.webm"

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };
  security.pam.enableSSHAgentAuth = true;
  security.pam.services.sudo.sshAgentAuth = true;
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
