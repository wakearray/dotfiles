{ ... }:
{
  config = {
    gui.firefox.enable = true;

    xdg.desktopEntries = {
      firefoxKent = {
        name = "Firefox Kent";
        icon = "firefox";
        genericName = "Web Browser";
        exec = "firefox -p \"kent\"";
        terminal = false;
        categories = [ "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" "application/xhtml+xml" ];
      };
      firefoxWgu = {
        name = "Firefox WGU";
        icon = "firefox";
        genericName = "Web Browser";
        exec = "firefox -p \"wgu\"";
        terminal = false;
        categories = [ "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" "application/xhtml+xml" ];
      };
    };
  };
}
