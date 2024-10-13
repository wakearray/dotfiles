{ lib, pkgs, config, ... }:
let
  cfg = config.fonts.fontconfig;
in
{
  # Install font/emoji packages here
  home.packages = with pkgs; [
    nerdfonts

    # Twitter Emoji
    twemoji-color-font

    # Emoji picker
    emojipick
  ];

#  home.activation = {
#    makeFontSymLink = lib.hm.dag.entryAfter [
#      "installPackages"
#      "reloadSystemd"
#      "checkFilesChanged"
#      "onFilesChange"
#      "linkGeneration"
#    ] ''
#      run ln -s
#    '';
#  };

  home = {
    sessionVariables = {
      # Home-manager fails to set these correctly,leading to an error
      FONTCONFIG_PATH = "/home/kent/.config/fontconfig/";
      FONTCONFIG_FILE = "/home/kent/.config/fontconfig/conf.d/10-hm-fonts.conf";
    };
  };
}
