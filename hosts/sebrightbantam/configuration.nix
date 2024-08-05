{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
  secrets = "/etc/nixos/secrets";
in
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "SebrightBantam"; # Define your hostname.

  # Enable networking.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kent = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    openssh.authorizedKeys.keys = with sshkeys; [
      greatblue samsung_s24 lenovo_y700 cubot_p80 boox_air_nova_c hisense_a9
    ];
  };

  programs.git.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Needed for hosting SSH File System
    sshfs

    # It's git
    git
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };
  security = {
    pam = {
      sshAgentAuth.enable = true;
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  # Forgejo
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.localhost";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "localhost";
        PROTOCOL = "http";
        HTTP_PORT = 8065;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  system.stateVersion = "24.05";
}
