{ config, pkgs, ... }:
{
  config = {
    home.wm.hyprland = {
      enable = true;
      modKey = "SUPER";
      settings = {
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitors = [
          "desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, auto-down, 1.666667"
          "desc:AOC 2279WH AHXJ49A007682, 1920x1080@60.00Hz, auto-up, 1"
          ", preferred, auto, 1"
        ];
        windowRules = [
          "workspace 2, class:^(Discord)(.*)"
          "workspace 2, class:^(Signal)(.*)"
          "workspace 2, class:^(Element)(.*)"
          "workspace 2, class:^(Telegram)(.*)"
          "workspace 4, class:^(Firefox)(.*)"
          "workspace 8, class:^(1Password)(.*)"
        ];
        execOnce = [
          "alacritty"
          "firefox"
          "signal-desktop"
          "${pkgs.eww}/bin/eww daemon"
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar"
        ];
        execShutdown = [
          "${pkgs.eww}/bin/eww close-all && pkill eww"
        ];
      };
    };
    gui.eww.battery.enable = true;
  };
}
