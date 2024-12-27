{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.gui.greeter.regreet;
in
{
  options.gui.greeter.regreet = with lib; {
    enable = mkEnableOption "Enable greetd with regreet to launch hyprland";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.regreet.package}/bin/regreet --time --cmd '${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop'";
          user = "greeter";
        };
      };
    };

    programs.regreet = {
      enable = true;
      theme = {
        name = "Adwaita";
        #package = ;
      };
      cursorTheme = {
        name = "Adwaita";
        #package = ;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "SauceCodePro NFM";
        size = 20;
        package = pkgs.nerd-fonts.sauce-code-pro;
      };
      #extraCss = "";
      settings = {
        #"background" = {
        #  # Path to the background image
        #  "path" = "/usr/share/backgrounds/greeter.jpg";

          # How the background image covers the screen if the aspect ratio doesn't match
          # Available values: "Fill", "Contain", "Cover", "ScaleDown"
          # Refer to: https://docs.gtk.org/gtk4/enum.ContentFit.html
          # NOTE: This is ignored if ReGreet isn't compiled with GTK v4.8 support.
        #  "fit" = "Contain";
        #};
        "GTK" = {
          # Whether to use the dark theme
          "application_prefer_dark_theme" = true;
        };
        "commands" = {
          # The command used to reboot the system
          "reboot" = [ "systemctl" "reboot" ];

          # The command used to shut down the system
          "poweroff" = [ "systemctl" "poweroff" ];
        };
        "appearance" = {
          # The message that initially displays on startup
          "greeting_msg" = "Welcome back!";
        };
      };
    };
  };
}
