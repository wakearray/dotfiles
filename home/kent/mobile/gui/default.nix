{ pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    # DarkTable - Virtual lighttable and darkroom for photographers
    # https://github.com/darktable-org/darktable
    darktable

    # dconf - Gnome system config, wanted by darktable
    dconf

    # Signal Messenger for desktop
    unstable.signal-desktop

    # scli - Terminal UI for Signal Messenger
    # https://github.com/isamert/scli
    unstable.scli

    # signal-cli - An unofficial dbus interface for Signal
    # https://github.com/AsamK/signal-cli
    unstable.signal-cli
  ];

  xsession.numlock.enable = true;

  programs = {
    alacritty = {
      settings = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "--login" "-c" "zellij" ];
        };
        font = {
          size = 18;
        };
      };
    };
  };
}
