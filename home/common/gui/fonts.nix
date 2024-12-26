{ config, pkgs, ... }:
let
  user = config.home.username;
in
{
  # home/common/gui/fonts
  # Determine what fonts should be used where
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Twitter Color Emoji SVGinOT" ];
        monospace = [ "SauceCodePro NFM" ];
        sansSerif = [ "SauceCodePro NFM" ];
        serif = [ "SauceCodePro NFM" ];
      };
    };
  };
  home = {
    packages = with pkgs; [
      # Sauce Code Pro Mono Nerdfont
      nerd-fonts.sauce-code-pro

      # Twitter Emoji
      # https://github.com/13rac1/twemoji-color-font
      twemoji-color-font
    ];
    sessionVariables = {
      # Home-manager fails to set these correctly,leading to an error
      FONTCONFIG_PATH = "/home/${user}/.config/fontconfig/";
      FONTCONFIG_FILE = "/home/${user}/.config/fontconfig/conf.d/10-hm-fonts.conf";
    };
  };
}
