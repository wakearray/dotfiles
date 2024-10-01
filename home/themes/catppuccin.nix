{ pkgs, lib, ... }:

{
  # Theme:
  # Catppuccin Macchiato
  # https://catppuccin.com/palette#flavor-macchiato
  #
  # #181926  #a5adcb  #eed49f
  # #1e2030  #b8c0e0  #f5a97f
  # #24273a  #cad3f5  #ee99a0
  # #363a4f  #b7bdf8  #ed8796
  # #494d64  #8aadf4  #c6a0f6
  # #5b6078  #7dc4e4  #f5bde6
  # #6e738d  #91d7e3  #f0c6c6
  # #8087a2  #8bd5ca  #f4dbd6
  # #939ab7  #a6da95
  #
  catppuccin = {
    # Enable the Catppuccin Macchiato theme globally
    enable = true;
    flavor = "macchiato";
    pointerCursor = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    style = {
      catppuccin = lib.mkOverride 10 {
        apply = true;
	enable = true;
      };
      name = lib.mkOverride 10 "kvantum";
    };
    platformTheme.name = lib.mkOverride 10 "kvantum";
  };

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons
  ];
}
