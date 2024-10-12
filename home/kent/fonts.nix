{ config, ... }:
let
  cfg = config.fonts.fontconfig;
in
{
  # Determine what fonts should be used where
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Twitter Color Emoji" ];
        monospace = [ "SauceCodePro Nerd Font Mono" ];
        sansSerif = [ "SauceCodePro Nerd Font Mono" ];
        serif = [ "SauceCodePro Nerd Font Mono" ];
      };
    };
  };


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

#  home = {
#    sessionVariables = {
#      # Home-manager fails to set these correctly,
#      # leading to an error
#      FONTCONFIG_PATH = "/home/kent/.config/fontconfig/conf.d/";
#      FONTCONFIG_FILE = "/home/kent/.config/fontconfig/conf.d/10-hm-fonts.conf";
#    };
#  };
}
