{ lib, config, pkgs, ... }:
let
  gtklock = config.home.locker.gtklock;
in
{
  options.home.locker.gtklock = with lib; {
    enable = mkEnableOption "Enable an opinionated gtklock configuration";

    gtkTheme = mkOption {
      type = types.str;
      default = "Adwaita-dark";
      description = "GTK3 theme you want applied to gtklock.";
    };

    style = mkOption {
      type = types.lines;
      default = /* css */ ''
        window {
          /* random picture of the day */
          background-image: url(https://bingw.jasonzeng.dev/?index=random);
          height: 100%;
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
          background-color: black;
        }
      '';
      description = "The contents of the GTK CSS file you want to use to apply additional styling. The best way to style gtklock is by running `$ GTK_DEBUG=interactive gtklock -li` and using the widget names as selectors. Some of the widgets are `#window-box`, `#clock-label`, `#body`, `#error-label` and `#input-label`.

[Note: The background url can be absolute or relative to the style file. If the image fails to load, the color is used.]";
    };

    modules = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        # Display userinfo on the lockscreen
        gtklock-userinfo-module
        # Adds power control buttons to the lockscreen
        gtklock-powerbar-module
        # Adds media player controls to the lockscreen
        gtklock-playerctl-module

        # https://github.com/progandy/gtklock-virtkb-module
        # Adds a virtual keyboard to the lockscreen
        #gtklock-virtkb-module

        # https://git.sr.ht/~aperezdc/gtklock-dpms-module
        # Blanks the screen after a set duration of inactivity
        #
        # Doesn't work correctly on hyprland and will hide the
        # password field while you're still typing
        #
        #gtklock-dpms-module
      ];
      description = "Packaged plugins you want to use with gtklock.";
    };

    timeFormat = mkOption {
      type = types.str;
      default = "%l:%M %p";
      description = "Specify a `strftime(3)` time format for the clock. https://www.man7.org/linux/man-pages/man3/strftime.3.html";
    };
  };

  config = lib.mkIf gtklock.enable {
    home = {
      packages = gtklock.modules;
    };

    xdg.configFile = {
      "gtklock/config.ini" = let
          moduleString = lib.concatMapStrings (x: "${x.outPath}/lib/gtklock/${builtins.substring 8 100 x.pname }.so;") gtklock.modules;
        in
        {
        enable = true;
        force = true;
        text = /* ini */ ''
          [main]
          gtk-theme=${gtklock.gtkTheme}
          style=style.css
          modules=${moduleString}
          time-format=${gtklock.timeFormat}
        '';
      };
      "gtklock/style.css" = {
        enable = true;
        force = true;
        text = gtklock.style;
      };
    };
  };
}
