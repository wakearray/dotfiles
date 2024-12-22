{ ... }:
{
  # home/jess/common/android/gui
  # GUI progams and settings for all Android devices
  # Use the following inside modules to ensure that they only build on hosts running an x11 window manager:
  #
  # { lib, system-details, ... }:{
  #   config = lib.mkIf (builtins.match "x11" system-details.display-type != null) {};
  # }
  #
  imports = [
    ./rofi.nix
  ];

  config = {
    gui = {
      wm.i3.enable = true;
      polybar.enable = true;
    };
  };
}
