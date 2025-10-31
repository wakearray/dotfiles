{ config, lib, ... }:
{
  # home/kent/common/gui/firefox
  config = lib.mkIf config.gui.enable {
    gui.firefox.enable = true;

    xdg.desktopEntries = {
      firefox = let
        firefoxBin = "${config.programs.firefox.finalPackage}/bin/firefox";
      in {
        actions = {
          new-private-window = {
            exec = "${firefoxBin} --private-window %U";
            name = "New Private Window";
          };
          new-window = {
            exec = "${firefoxBin}/bin/firefox --new-window %U";
            name = "New Window";
          };
        };
        name = "Firefox";
        icon = "firefox";
        genericName = "Web Browser";
        exec = "${firefoxBin} --name firefox %U";
        terminal = false;
        categories = [ "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
        startupNotify = true;
        type = "Application";
      };
    };
  };
}
