{ ... }:
{
  # home/entertainment/common/gui
  imports = [
    ./firefox.nix
  ];

  config = {
    gui = {
      themes.gruvbox.enable = true;
      pcmanfm.enable = true;
    };
  };
}
