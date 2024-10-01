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
      };
    };
  };
}
