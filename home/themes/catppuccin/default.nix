{ pkgs, config, lib, ... }:
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

  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk;
      name = "macchiato";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  programs = {
    vscode.extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
    eww.configDir = ./eww;
  };

  gui = {
    rofi.theme =
    let
      # Use `mkLiteral` for string-like values that should show without
      # quotes, e.g.:
      # {
      #   foo = "abc"; => foo: "abc";
      #   bar = mkLiteral "abc"; => bar: abc;
      # };
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col = mkLiteral "#24273A";
        bg-col-light = mkLiteral "#24273A";
        border-col = mkLiteral "#24273A";
        selected-col = mkLiteral "#24273A";
        blue = mkLiteral "#8AADf4";
        fg-col = mkLiteral "#CAD3F5";
        fg-col2 = mkLiteral "#ED8796";
        grey = mkLiteral "#6e738d";

        width = 600;
      };

      "element-text, element-icon , mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "window" = {
        height = mkLiteral "360px";
        border = mkLiteral "3px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
      };

      "mainbox" = {
        background-color = mkLiteral "@bg-col";
      };

      "inputbar" = {
        children = mkLiteral "[prompt,entry]";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "5px";
        padding = mkLiteral "2px";
      };

      "prompt" = {
        background-color = mkLiteral "@blue";
        padding = mkLiteral "6px";
        text-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "3px";
        margin = mkLiteral "20px 0px 0px 20px";
      };

      "textbox-prompt-colon" = {
        expand = false;
        str = ":";
      };

      "entry" = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 10px";
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col";
      };

      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "10px 0px 0px 20px";
        columns = mkLiteral "2";
        lines = mkLiteral "5";
        background-color = mkLiteral "@bg-col";
      };

      "element" = {
        padding = mkLiteral "5px";
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
      };

      "element-icon" = {
        size = mkLiteral "25px";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col ";
        text-color = mkLiteral "@fg-col2";
      };

      "mode-switcher" = {
        spacing = mkLiteral "0";
      };

      "button" = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@blue";
      };

      "message" = {
        background-color = mkLiteral "@bg-col-light";
        margin = mkLiteral "2px";
        padding = mkLiteral "2px";
        border-radius = mkLiteral "5px";
      };

      "textbox" = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 20px";
        text-color = mkLiteral "@blue";
        background-color = mkLiteral "@bg-col-light";
      };
    };
  };
}
