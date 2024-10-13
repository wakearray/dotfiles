{ ... }:
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
          normal = {
            family = "SauceCodePro NFM";
            style = "Regular";
          };
          bold = {
            family = "SauceCodePro NFM";
            style = "SemiBold";
          };
          italic = {
            family = "SauceCodePro NFM";
            style = "Italic";
          };
          bold_italic = {
            family = "SauceCodePro NFM";
            style = "SemiBold Italic";
          };
        };
      };
    };
  };
}
