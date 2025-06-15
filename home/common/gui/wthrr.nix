{ lib, config, pkgs, ... }:
let
  wthrr = config.programs.wthrr;
in
{
  options.programs.wthrr = with lib; {
    enable = mkEnableOption "Enable wthrr, a tui weather program written in rust using Open Meteo and write a configurable opinionated defaults config file. https://github.com/ttytm/wthrr-the-weathercrab";

    address = mkOption {
      type = with types; nullOr str;
      default = "Ashburn,US";
      description = "String of address to check the weather, e.g.: \"Berlin,DE\"";
    };

    # TODO: Use environment $LANG variable to set this automatically
    language = mkOption {
      type = types.str;
      default = "en_US";
      description = "Language code of the output language.";
    };

    forecast = mkOption {
      type = with types; nullOr (enum [ "day" "week" "day, week" ]);
      default = null;
      description = "Forecast to display without adding the `-f` option. Set to null to disable forcasts without using the `-f` option.";
    };

    units = {
      temperature = mkOption {
        type = types.enum [ "celsius" "fahrenheit" ];
        default = "fahrenheit";
        description = "Desired temperature units.";
      };

      speed = mkOption {
        type = types.enum [ "kmh" "mph" "knots" "ms" ];
        default = "mph";
        description = "Desired wind speed units.";
      };

      time = mkOption {
        type = types.enum [ "military" "am_pm" ];
        default = "am_pm";
        description = "Desired time format.";
      };

      precipitation = mkOption {
        type = types.enum [ "probability" "mm" "inch" ];
        default = "probability";
        description = "Desired precipitation units.";
      };
    };

    gui = {
      border = mkOption {
        type = types.enum [ "rounded" "single" "solid" "double" ];
        default = "rounded";
        description = "Desired border style";
      };

      color = mkOption {
        type = types.enum [ "default" "plain" ];
        default = "default";
        description = ""; # TODO: What is plain? Is it black and white?
      };

      graph = {
        style = mkOption {
          type = with types; oneOf [ (enum [ "lines(solid)" "lines(slim)" "lines(dotted)" "dotted" ]) (listOf str) ];
          default = "dotted";
          description = "Desired graph style. For a custom style, provide a list of 8 chars. e.g. `[ \"⡀\" \"⡀\" \"⠄\" \"⠄\" \"⠂\" \"⠂\" \"⠁\" \"⠁\" ]`.";
        };
        rowspan = mkOption {
          type = types.enum [ "single" "double" ];
          default = "single";
          description = "Desired graph height.";
        };
        timeIndicator = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable the time indicator on graphs.";
        };
      };

      greeting = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to display the greeting message.";
      };
    };
  };

  config = lib.mkIf wthrr.enable {
    home = {
      packages = [
        # A rust tui for getting the weather
        # https://github.com/ttytm/wthrr-the-weathercrab
        pkgs.wthrr
      ];

      file = {
        ".config/weathercrab/wthrr.ron" = {
          enable = true;
          force = true;
          text = /* ron */ ''
  (
      address: "${wthrr.address}",
      language: "${wthrr.language}",
      forecast: [${builtins.toString wthrr.forecast}],
      units: (
          temperature: ${wthrr.units.temperature},
          speed: ${wthrr.units.speed},
          time: ${wthrr.units.time},
          precipitation: ${wthrr.units.precipitation},
      ),
      gui: (
          border: ${wthrr.gui.border},
          color: ${wthrr.gui.color},
          graph: (
              style: ${wthrr.gui.graph.style},
              rowspan: ${wthrr.gui.graph.rowspan},
              time_indicator: ${lib.boolToString wthrr.gui.graph.timeIndicator},
          ),
          greeting: ${lib.boolToString wthrr.gui.greeting},
      ),
  )
          '';
        };
      };
    };
  };
}
