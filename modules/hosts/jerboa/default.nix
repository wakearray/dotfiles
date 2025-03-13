{ pkgs, ... }:
{
  # /modules/hosts/jerboa
  environment.systemPackages = with pkgs; [
    # Music player
    clementine
  ];

  gui = {
    enable = true;
    gaming.enable = true;
    wm.hyprland.enable = true;
    greeter.tuigreet = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "entertainment";
      };
    };
  };

  servers = {
    home-assistant.enable = true;
  };
}
