{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.clementine
    firefox

    # Alacritty -
    # https://github.com/alacritty/alacritty
    unstable.alacritty
    unstable.alacritty-theme
  ];
}
