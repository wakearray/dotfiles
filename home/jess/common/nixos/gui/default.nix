{ ... }:
{
  # home/jess/common/nixos/gui
  # GUI progams and settings applicable to all nixos systems (does not include Android)
  # Use the following inside modules to ensure that they only build on hosts running a wayland based window manager:
  #
  # { lib, system-details, ... }:{
  #   config = lib.mkIf (builtins.match "wayland" system-details.display-type != null) {};
  # }
  #
  imports = [
    ./rofi.nix
  ];
}
