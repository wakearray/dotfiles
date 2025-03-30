{ pkgs, ... }:
{
  # /modules/hosts/jerboa
  imports = [
    ./tuigreet.nix
  ];

  environment.systemPackages = with pkgs; [
    # Music player
    clementine
  ];

  gui = {
    enable = true;
    gaming.enable = true;
    wm.hyprland.enable = true;
  };

  servers = {
    home-assistant = {
      enable = true;
      bridge = {
        name = "br0";
        interface = "enp1s0";
      };
    };
  };
}
