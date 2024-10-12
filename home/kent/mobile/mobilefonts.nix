{ pkgs, ... }:
{
  # Install font/emoji packages here
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })

    # Twitter Emoji
    twemoji-color-font

    # Emoji picker
    emojipick
  ];
}
