{ system-details, lib, config, pkgs, ... }:
let
  isAndroid = (builtins.match "android" system-details.host-type    != null);
  isX11     = (builtins.match "x11"     system-details.display-type != null);
  isWayland = (builtins.match "wayland" system-details.display-type != null);
  cfg = config.android.gui;
in
{
  # home/kent/common/android/gui
  imports = [
    ./rofi.nix
    ./wayland
  ];

  options.android.gui = with lib; {
    enable = mkOption {
      type = types.bool;
      default = ((isAndroid) && ((isX11) || (isWayland)));
      description = "Defaults to true if device is Android and system-details.display-type isn't `none`.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # DarkTable - Virtual lighttable and darkroom for photographers
      # https://github.com/darktable-org/darktable
      darktable

      # dconf - Gnome system config, wanted by darktable
      dconf
    ];

    xsession.numlock.enable = true;
  };
}
