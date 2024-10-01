{ pkgs, ... }:
{
  programs = {
    # imv - a command line image viewer intended for use with tiling window managers
    # https://sr.ht/~exec64/imv/
    imv.enable = true;

    # mpv - Command line video player
    # https://github.com/mpv-player/mpv
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mpv.enable
    mpv.enable = true;

    # rofi - A window switcher, application launcher and dmenu replacement
    # https://github.com/davatorium/rofi
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.enable
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };

  services = {
    # dunst - Lightweight and customizable notification daemon
    # https://github.com/dunst-project/dunst
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
    dunst.enable = true;
  };
}
