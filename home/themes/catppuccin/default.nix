{ pkgs, config, lib, ... }:
let
  # https://catppuccin.com/palette
  colors = {
    latte = {
      rosewater = "#dc8a78";
      flamingo  = "#dd7878";
      pink      = "#ea76cb";
      mauve     = "#8839ef";
      red       = "#d20f39";
      maroon    = "#e64553";
      peach     = "#fe640b";
      yellow    = "#df8e1d";
      green     = "#40a02b";
      teal      = "#179299";
      sky       = "#04a5e5";
      sapphire  = "#209fb5";
      blue      = "#1e66f5";
      lavender  = "#7287fd";
      text      = "#4c4f69";
      subtext-1 = "#5c5f77";
      subtext-0 = "#6c6f85";
      overlay-2 = "#7c7f93";
      overlay-1 = "#8c8fa1";
      overlay-0 = "#9ca0b0";
      surface-2 = "#acb0be";
      surface-1 = "#bcc0cc";
      surface-0 = "#ccd0da";
      base      = "#eff1f5";
      mantle    = "#e6e9ef";
      crust     = "#dce0e8";
    };
    macchiato = {
      rosewater = "#f4dbd6";
      flamingo  = "#f0c6c6";
      pink      = "#f5bde6";
      mauve     = "#c6a0f6";
      red       = "#ed8796";
      maroon    = "#ee99a0";
      peach     = "#f5a97f";
      yellow    = "#eed49f";
      green     = "#a6da95";
      teal      = "#8bd5ca";
      sky       = "#91d7e3";
      sapphire  = "#7dc4e4";
      blue      = "#8aadf4";
      lavender  = "#b7bdf8";
      text      = "#cad3f5";
      subtext-1 = "#b8c0e0";
      subtext-0 = "#a5adcb";
      overlay-2 = "#939ab7";
      overlay-1 = "#8087a2";
      overlay-0 = "#6e738d";
      surface-2 = "#5b6078";
      surface-1 = "#494d64";
      surface-0 = "#363a4f";
      base      = "#24273a";
      mantle    = "#1e2030";
      crust     = "#181926";
    };
  };
in
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
  };

  gui = {
    eww = {
      bar = {
        colors = {
          fg-1 = colors.fg_0;
          fg-2 = colors.fg_1;
          bg-1 = colors.bg_0;
          bg-2 = colors.bg_1;
          accent-1 = colors.fg_orange;
          accent-2 = colors.fg_yellow;
        };
      };
    };
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
