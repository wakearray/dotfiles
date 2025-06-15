{ ... }:
{
  # home/jess/common
  # Programs and settings that should be present on all hosts that Jess has a profile on
  imports = [
    ./android
    ./gui
    ./git.nix
    ./nixos
  ];
}
