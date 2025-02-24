{ pkgs, ... }:
{
  i3wsr-3 = pkgs.callPackage ./i3wsr-3 {};
  signal-desktop-arch = pkgs.callPackage ./signal-desktop {};
}
