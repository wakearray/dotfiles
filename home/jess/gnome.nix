{ lib, config, ... }:
{
  config = lib.mkIf config.gui.wm.gnome.enable {
    services = {
      # dunst - Lightweight and customizable notification daemon
      # https://github.com/dunst-project/dunst
      # More options found here:
      # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
      dunst.enable = true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        clock-show-weekday = false;
        color-scheme = "prefer-dark";
        font-antialiasing = "grayscale";
        font-hinting = "slight";
        gtk-enable-primary-paste = false;
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
  };
}
