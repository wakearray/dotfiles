{ system-details, ... }:
{
  # home/jess/common
  # Programs and settings that should be present on all hosts that Jess has a profile on
  imports = [
    ./gui
    ./git.nix
    (
      if
        builtins.match "android" system-details.host-type != null
      then
        ./android
      else
        ./nixos
    )
  ];
}
