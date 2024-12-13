{ lib, ... }:
{
  imports = [
    ./eww.scss.nix
    ./eww.yuck.nix
    ./img
  ];

  options.gui.eww.bar = with lib; {
    enable = mkEnableOption "Enable a generic bar config for eww.";

    colors = {
      fg-1 = mkOption {
        type = types.str;
        default = "#D4BE98";
        description = "A color to use for foreground elements like text";
      };

      fg-2 = mkOption {
        type = types.str;
        default = "#DDC7A1";
        description = "A color to use for foreground elements like text";
      };

      bg-1 = mkOption {
        type = types.str;
        default = "#282828";
        description = "A color to use for background elements";
      };

      bg-2 = mkOption {
        type = types.str;
        default = "#32302F";
        description = "A color to use for background elements";
      };

      accent-1 = mkOption {
        type = types.str;
        default = "#E78A4E";
        description = "A color to use for primary accent elements";
      };

      accent-2 = mkOption {
        type = types.str;
        default = "#D8A657";
        description = "A color to use for secondary accent elements";
      };
    };
  };
}
