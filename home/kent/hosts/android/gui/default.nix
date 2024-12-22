{ system-details, lib, pkgs, ... }:
{
  imports = [
    ./rofi.nix
  ];

  config = lib.mkIf (builtins.match "x11" system-details.display-type != null) {
    home.packages = with pkgs; [
      # DarkTable - Virtual lighttable and darkroom for photographers
      # https://github.com/darktable-org/darktable
      darktable

      # dconf - Gnome system config, wanted by darktable
      dconf

      # scli - Terminal UI for Signal Messenger
      # https://github.com/isamert/scli
      scli

      # signal-cli - An unofficial dbus interface for Signal
      # https://github.com/AsamK/signal-cli
      signal-cli
    ];

    xsession.numlock.enable = true;

    programs.alacritty.settings.font.size = 18;

    gui = {
      wm.i3.enable = true;
      polybar.enable = true;
      themes.gruvbox.enable = true;
    };
  };
}
