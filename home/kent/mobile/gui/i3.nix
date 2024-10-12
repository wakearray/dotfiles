{ ... }:
{
  # i3
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "0: term" = [{ class = "Alacritty"; }];
          "1: discord" = [{ class = "Firefox-esr"; }];
          "2: web" = [{ class = "Firefox-esr"; }];
        };
        fonts = {
          names = [ "SauceCodePro Nerd Font Mono" ];
          style = "Regular";
          size = 12.0;
        };
      };
    };
  };
}
