{ lib, ... }:

let
  # Define regex patterns for each color format
  rgbPattern = ''^rgb\(\s*(\d{1,3}%?),\s*(\d{1,3}%?),\s*(\d{1,3}%?)\s*\)$'';
  rgbaPattern = ''^rgba\(\s*(\d{1,3}%?),\s*(\d{1,3}%?),\s*(\d{1,3}%?),\s*(0|0?\.\d+|1(\.0)?)\s*\)$'';
  hexPattern = ''^(#([0-9a-fA-F]{6})([0-9a-fA-F]{2})?)$'';

  # Function to validate if a color string matches any of the defined patterns
  isValidColor = colorStr: builtins.any (pattern:
    builtins.match pattern colorStr != null
  ) [rgbPattern rgbaPattern hexPattern];

  # Define a custom type for colors using the validation function
  types = lib.types // {
    color = lib.types.strMatching (colorStr: if isValidColor colorStr then true else throw "Invalid color format: ${colorStr}");
  };
in
{
  imports = [
    # ./catppuccin
    ./gruvbox
  ];

  # Example of how to use the color type:
  options = {
    myService.colorOption = {
      type = types.color;
      description = "A color option supporting various formats (RGB, RGBA, Hex).";
      default = "#ff00cc"; # Default value in a valid format
    };
  };

  config = {};
}
