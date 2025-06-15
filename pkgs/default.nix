{ pkgs, ... }:
{
  i3wsr-3 = pkgs.callPackage ./i3wsr-3 {};
  signal-desktop-arch = pkgs.callPackage ./signal-desktop {};
  gtklock-virtkb-module = pkgs.callPackage ./gtklock-virtkb-module {};
  gtklock-dpms-module = pkgs.callPackage ./gtklock-dpms-module {};
}
