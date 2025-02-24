{ ... }:
{
  # home/jess/common/nixos/gui
  # GUI progams and settings applicable to all nixos systems (does not include Android)
  imports = [
    ./rofi.nix
  ];
}
