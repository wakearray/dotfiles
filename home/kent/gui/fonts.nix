{ pkgs, ... }:
{
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
  home.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
  ];
}
