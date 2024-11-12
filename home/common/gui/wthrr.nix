{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # A rust tui for getting the weather
      # https://github.com/ttytm/wthrr-the-weathercrab
      wthrr
    ];
    file = {
      ".config/weathercrab/wthrr.ron" = {
        enable = true;
        force = true;
        text = ''
(
    address: "Ashburn,US", // Address to check the weather, e.g.: "Berlin,DE"
    language: "en_US", // Language code of the output language
    forecast: [day, week], // Forecast to display without adding the `-f` option: `[day]` | `[week]` | `[day, week]`
    units: (
        temperature: fahrenheit, // Temperature units: `celsius` | `fahrenheit`
        speed: mph, // (Wind)speed units: `kmh` | `mph` | `knots` | `ms`
        time: am_pm, // Time Format: `military` | `am_pm`
        precipitation: probability, // Precipitation units: `probability` | `mm` | `inch`
    ),
    gui: (
        border: rounded, // Border style: `rounded` | `single` | `solid` | `double`
        color: default, // Color: `default` | `plain`
        graph: (
            // Graph style: lines(solid) | lines(slim) | lines(dotted) | dotted | custom((char; 8))
            // `custom` takes exactly 8 chars. E.g. using a set of 4 chars: `custom(('⡀','⡀','⠄','⠄','⠂','⠂','⠁','⠁'))`,
            style: dotted,
            rowspan: double, // Graph height: `double` | `single`
            time_indicator: true, // Indication of the current time in the graph: `true` | `false`
        ),
        greeting: false, // Display greeting message: `true` | `false`
    ),
)
        '';
      };
    };
  };
}
