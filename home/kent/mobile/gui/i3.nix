{ ... }:
{
  # i3
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        fonts = {
          names = [ "SauceCodePro NFM" ];
          style = "Regular";
          size = 12.0;
        };
      };
    };
  };
}
