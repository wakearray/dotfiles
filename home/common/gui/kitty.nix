{ config, lib, pkgs, ... }:
let
  cfg = config.gui.kitty;
in
{
  options.gui.kitty = with lib; {
    enable = mkEnableOption "Enable an opinionated Kitty config.";

    fontSize = mkOption {
      type = types.int;
      default = 12;
      description = "Change the font size per machine.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        package = pkgs.nerd-fonts.sauce-code-pro;
        name = "SauceCodePro NFM";
        size = cfg.fontSize;
      };
      themeFile = "GruvboxMaterialDarkMedium";

      # attribute set of (string or boolean or signed integer or floating point number)
      # https://sw.kovidgoyal.net/kitty/conf/
      # settings = {};
    };
  };
}
