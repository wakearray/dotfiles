{ ... }:
{
  imports = [
    ./hyprland.nix
  ];

  config = {
    gui = {
      cliphist.enable = true;
      themes.gruvbox.enable = true;
      alacritty.enable = true;
    };
  };
}
