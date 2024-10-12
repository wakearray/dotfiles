{ ... }:
{
  programs.urxvt = {
    enable = true;
    fonts = [
      "xft:SauceCodePro NFM Light:size=20"
    ];
    scroll.bar.enable = false;
    extraConfig = {
      boldFont = [
        "xft:SauceCodePro NFM SemiBold:size=20"
      ];
      italicFont = [
        "xft:SauceCodePro NFM SemiBold:size=20"
      ];
      boldItalicFont = [
        "xft:SauceCodePro NFM SemiBold:style=SemiBold Italic:size=20"
      ];
      # GruvboxDark Colors
      # hard contrast: background = "#1d2021"
      # soft contrast: background = "#32302f"
      background = "#282828";
      foreground = "#ebdbb2";
      color0 = "#282828";
      color8 = "#928374";
      color1 = "#cc241d";
      color9 = "#fb4934";
      color2 = "#98971a";
      color10 = "#b8bb26";
      color3 = "#d79921";
      color11 = "#fabd2f";
      color4 = "#458588";
      color12 = "#83a598";
      color5 = "#b16286";
      color13 = "#d3869b";
      color6 = "#689d6a";
      color14 = "#8ec07c";
      color7 = "#a89984";
      color15 = "#ebdbb2";

      # Remove border chrome
      borderLess = true;

      # Enables using font glyphs instead
      skipBuiltinGlyphs = true;
    };
  };
}
