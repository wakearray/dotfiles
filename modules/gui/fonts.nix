{ pkgs, lib, config, ... }:
let
  gui = config.gui;
in
{
  config = lib.mkIf gui.enable {
    fonts = {
      packages = with pkgs; [
        # Better emojis
        twemoji-color-font

        # Nerdfonts
        nerd-fonts.sauce-code-pro
      ];
      fontconfig = {
        # Hopefully fixes annoying rofi error messages
        cache32Bit = true;
        defaultFonts = {
          emoji = [ "Twitter Color Emoji SVGinOT" ];
          monospace = [ "SauceCodePro NFM" ];
          sansSerif = [ "SauceCodePro NFM" ];
          serif = [ "SauceCodePro NFM" ];
        };
      };
    };
    # Set the font of the terminal prior to full system start
#    console = {
#      earlySetup = true;
#      font = "SauceCodePro NFM";
#      packages = with pkgs; [ nerd-fonts.sauce-code-pro ];
#      keyMap = "us";
#    };
  };
}
