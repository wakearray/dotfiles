{ pkgs, ... }:
{
  imports = [
    ./starship.nix
    ./hyprland.nix
    ./moonlight.nix
  ];

  config = {
    programs = {
      # imv - a command line image viewer intended for use with tiling window managers
      # https://sr.ht/~exec64/imv/
      imv.enable = true;

      llmClients.enable = true;
    };

    gui = {
      cliphist.enable = true;
      eww.enable = true;
      themes.gruvbox.enable = true;
      vscode.enable = true;
      rofi.rofiNetworkManager.enable = true;
    };

    home = {
      packages = with pkgs; [
        # TTS
        piper-tts
        sox

        # Chrome
        google-chrome

        # Image editing
        gimp3-with-plugins
        darktable
        rawtherapee
        exiftool
        inkscape

        # 3D Modeling
        blender
        openscad-unstable

        # GTK patchbay for pipewire
        # https://gitlab.freedesktop.org/pipewire/helvum
        helvum

        # qt6ct for theming QT applications
        qt6Packages.qt6ct
      ];

      locker.gtklock = {
        enable = true;
        modules = with pkgs; [
          # Display userinfo on the lockscreen
          gtklock-userinfo-module
          # Adds power control buttons to the lockscreen
          gtklock-powerbar-module
          # Adds media player controls to the lockscreen
          gtklock-playerctl-module

          # https://github.com/progandy/gtklock-virtkb-module
          # Adds a virtual keyboard to the lockscreen
          # (Covers up the powerbar module if enabled)
          gtklock-virtkb-module
        ];
      };
    };
  };
}
