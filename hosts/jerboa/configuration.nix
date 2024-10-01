{ pkgs, ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/gui
    ../../modules/jerboa
    ../../users/kent
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "Jerboa"; # TV computer
    networkmanager.enable = true;
  };

  users.users.tv = {
    isNormalUser = true;
    description = "TV";
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
      firefox
      google-chrome
      unstable.clementine
    ];
  };

  #### Gnome stuff ####

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "tv";
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  # Gnome packages I don't want.
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    epiphany # web browser
    geary # email reader
    evince # document viewer
    rygel # UPnP server
  ]);

  environment.systemPackages = with pkgs; [
      gnome-menus
      gnome.gnome-tweaks
  ];

  programs.gnome-terminal.enable = true;
  services.gnome = {
    core-shell.enable = true;
    sushi.enable = true;
  };
    #### End of Gnome stuff ####

  system.stateVersion = "23.11"; # Did you read the comment?
}
