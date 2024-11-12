{ config, pkgs, ... }:
let
  #display-system = config.host-options.display-system;
  host-type = config.host-options.host-type;
  system = builtins.currentSystem;
in
{
  imports = [
    ./alacritty.nix
    ./mpv.nix
    ./rofi.nix
    ./wthrr.nix

    (if builtins.match "aarch64-linux" system != null then ./aarch64-gui.nix else null)
    (if builtins.match "x86_64-linux" system != null then ./x86_64-gui.nix else null)
    (if builtins.match "mobile" host-type != null then ./mobile else null)
  ];

  home.packages = with pkgs; [
    # Keepassxc - Offline password store
    keepassxc
  ];
}
