{ lib, ... }:
{
  programs = {
    # alacritty - A cross-platform, OpenGL terminal emulator
    # https://github.com/alacritty/alacritty
    alacritty = {
      enable = true;
      settings = {
        selection = {
          save_to_clipboard = true;
	      };
        cursor = {
          style = {
	          shape = "Underline";
	          blinking = "Off";
	        };
	      };
        terminal = {
          osc52 = "CopyPaste";
	      };
        mouse = {
          bindings = [{
	          mouse = "Middle";
	          action = "Paste";
	        }];
	      };
        font = {
          normal = lib.mkOverride 1001 {
            family = "SauceCodePro NFM";
            style = "Regular";
          };
          bold = lib.mkOverride 1001 {
            family = "SauceCodePro NFM";
            style = "SemiBold";
          };
          italic = lib.mkOverride 1001 {
            family = "SauceCodePro NFM";
            style = "Italic";
          };
          bold_italic = lib.mkOverride 1001 {
            family = "SauceCodePro NFM";
            style = "SemiBold Italic";
          };
        };
        # TODO: Make this theme optional through config option
        # Gruvbox Material Medium Dark
        colors.primary = lib.mkOverride 1001 {
          background = "0x282828";
          foreground = "0xd4be98";
        };
        colors.normal = lib.mkOverride 1001 {
          black = "0x3c3836";
          red = "0xea6962";
          green = "0xa9b665";
          yellow = "0xd8a657";
          blue = "0x7daea3";
          magenta = "0xd3869b";
          cyan = "0x89b482";
          white = "0xd4be98";
        };
        colors.bright = lib.mkOverride 1001 {
          black = "0x3c3836";
          red = "0xea6962";
          green = "0xa9b665";
          yellow = "0xd8a657";
          blue = "0x7daea3";
          magenta = "0xd3869b";
          cyan = "0x89b482";
          white = "0xd4be98";
        };
      };
    };
  };
}
