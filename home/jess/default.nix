{ lib, config, pkgs, ... }:

{
  imports = [
    ./starship.nix
  ];

  home = {
    username = "jess";
    homeDirectory = "/home/jess";
    stateVersion = "24.05";
    #packages = with pkgs; [
      # 
    #];
  };

  # Theme:
  # Catppuccin Macchiato
  #
  # #494D64  #5B6078
  # #ED8796  #ED8796
  # #A6DA95  #A6DA95
  # #EED49F  #EED49F
  # #8AADF4  #7AADF4
  # #F5BDE6  #F5BDE6
  # #8BD5CA  #8BD5CA
  # #B8C0E0  #A5ADCB

  # Editor Config helps enforce your preferences on editors
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 78;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

  programs = {
    home-manager.enable = true;
  };
 
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = false;
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-enable-primary-paste = false;
      gtk-theme = "Adwaita-dark";
      monospace-font-name = "Source Code Pro Light 10";
      show-battery-percentage = false;
    };
    "org/gnome/nautilus/icon-view" = {
      captions = [ "size" "date_modified" "none"];
      default-zoom-level = "small";
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      show-delete-permanently = true;
    };
    "org/gnome/desktop/session" = { 
      idle-delay= lib.gvariant.mkUint32 0;
    };
  };
}
