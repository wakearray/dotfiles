{ pkgs, ... }:
{
  # Defaults for any GUI specific applications that I want on every GUI capable computer
  imports = [
    ./sound.nix
    ./gaming.nix
    ./wm
  ];

  fonts.packages = with pkgs; [
    # Better emojis
    twemoji-color-font

    # Nerdfonts
    unstable.nerdfonts
  ];
}
