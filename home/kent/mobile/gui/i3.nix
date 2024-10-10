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
          "1: discord" = [{ class = "Discord"; }];
          "2: web" = [{ class = "Firefox"; }];
        };
      };
    };
  };
}
