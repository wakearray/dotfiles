{ lib, config, pkgs, ... }:
let
  isAndroid = config.home.systemDetails.isAndroid;
  gui = config.gui;
  agui = config.android.gui;
in
{
  # home/kent/common/android/gui
  imports = [
    ./rofi.nix
    #./wayland
  ];

  options.android.gui = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (isAndroid && gui.enable);
      description = "Defaults to true if device is Android and systemDetails.display isn't `cli`.";
    };
  };

  config = lib.mkIf agui.enable {
    home.packages = with pkgs; [
      # DarkTable - Virtual lighttable and darkroom for photographers
      # https://github.com/darktable-org/darktable
      darktable

      # dconf - Gnome system config, wanted by darktable
      dconf

      # Signal-desktop, specifically for arch
      # Waiting on pull request to be accepted
      # https://github.com/NixOS/nixpkgs/pull/384032
      signal-desktop-arch
    ];

    xsession.numlock.enable = true;
  };
}
