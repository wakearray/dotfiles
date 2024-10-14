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
        # The definition of color schemes.
        schemes = {
          gruvbox_material_hard_dark = {
            primary = {
              background = "0x1d2021";
              foreground = "0xd4be98";
            };
            normal = {
              black = "0x32302f";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              cyan = "0x89b482";
              white = "0xd4be98";
            };
            bright = {
              black = "0x32302f";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              cyan = "0x89b482";
              white = "0xd4be98";
            };
          };
          gruvbox_material_medium_dark = {
            primary = {
              background = "0x282828";
              foreground = "0xd4be98";
            };
            normal = {
              black = "0x3c3836";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              cyan = "0x89b482";
              white = "0xd4be98";
            };
            bright = {
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
          gruvbox_material_soft_dark = {
            primary = {
              background = "0x32302f";
              foreground = "0xd4be98";
            };
            normal = {
              black = "0x45403d";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              cyan = "0x89b482";
              white = "0xd4be98";
            };
            bright = {
              black = "0x45403d";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              cyan = "0x89b482";
              white = "0xd4be98";
            };
          };
          gruvbox_material_hard_light = {
            primary = {
              background = "0xf9f5d7";
              foreground = "0x654735";
            };
            normal = {
              black = "0x654735";
              red = "0xc14a4a";
              green = "0x6c782e";
              yellow = "0xb47109";
              blue = "0x45707a";
              magenta = "0x945e80";
              cyan = "0x4c7a5d";
              white = "0xf2e5bc";
            };
            bright = {
              black = "0x654735";
              red = "0xc14a4a";
              green = "0x6c782e";
              yellow = "0xb47109";
              blue = "0x45707a";
              magenta = "0x945e80";
              cyan = "0x4c7a5d";
              white = "0xf2e5bc";
            };
          };
          gruvbox_material_medium_light = {
            primary = {
              background = "0xfbf1c7";
              foreground = "0x654735";
            };
            normal = {
              black = "0x654735";
              red = "0xc14a4a";
              green = "0x6c782e";
              yellow = "0xb47109";
              blue = "0x45707a";
              magenta = "0x945e80";
              cyan = "0x4c7a5d";
              white = "0xeee0b7";
            };
            bright = {
              black = "0x654735";
              red = "0xc14a4a";
              green = "0x6c782e";
              yellow = "0xb47109";
              blue = "0x45707a";
              magenta = "0x945e80";
              cyan = "0x4c7a5d";
              white = "0xeee0b7";
            };
          };
          gruvbox_material_soft_light = {
            primary = {
              background = "0xf2e5bc";
              foreground = "0x654735";
            };
            normal = {
              black = "0x654735";
              red = "0xc14a4a";
              green = "0x6c782e";
              yellow = "0xb47109";
              blue = "0x45707a";
              magenta = "0x945e80";
              cyan = "0x4c7a5d";
              white = "0xe6d5ae";
            };
            bright = {
              black = "0x654735";
              red = "0xc14a4a";
              green = "0x6c782e";
              yellow = "0xb47109";
              blue = "0x45707a";
              magenta = "0x945e80";
              cyan = "0x4c7a5d";
              white = "0xe6d5ae";
            };
          };
        };
        # Apply the color scheme.
        colors = "*gruvbox_material_medium_dark";
      };
    };
  };
}
