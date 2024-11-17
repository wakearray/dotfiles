{ pkgs, ... }:
{
  i3wsr-3 = pkgs.unstable.callPackage ./i3wsr-3 {};
}
