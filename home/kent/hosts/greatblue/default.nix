{ pkgs, ... }:
{
  imports = [
    ./starship.nix
    ./hyprland.nix
    ./hyprlock.nix
  ];
  config = {
    programs = {
      # imv - a command line image viewer intended for use with tiling window managers
      # https://sr.ht/~exec64/imv/
      imv.enable = true;
    };

    gui = {
      cliphist.enable = true;
      themes.gruvbox.enable = true;
      alacritty.enable = true;
      vscode.enable = true;
    };

    home.packages = with pkgs; [
      wev
      wlprop

      # TTS
      piper-tts
      sox

      # Chrome
      google-chrome

      # Image editing
      gimp-with-plugins
      darktable
      rawtherapee
      exiftool
      inkscape

      # 3D Modeling
      blender
      openscad-unstable
    ];
  };
}
