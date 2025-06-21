{ ... }:
{
  # home/entertainment/common/gui
  imports = [
    ./firefox.nix
  ];

  config = {
    gui = {
      pcmanfm.enable = true;
    };
  };
}
