{ pkgs, lib, config, ...}:
let
  gui = config.gui;
  rofi = gui.rofi;

  isWayland = config.home.systemDetails.display.wayland;
in
{
  options.gui.rofi = with lib; {
    enable = mkEnableOption "Enable an opionated Rofi configuration";

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };

    modi = mkOption {
      type = types.commas;
      default = "drun,window,todo:todofi.sh,filebrowser";
    };

    theme = mkOption {
      type = types.nullOr types.attrs;
      default = let
        # Use `mkLiteral` for string-like values that should show without
        # quotes, e.g.:
        # {
        #   foo = "abc"; => foo: "abc";
        #   bar = mkLiteral "abc"; => bar: abc;
        # };
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        # ROUNDED THEME FOR ROFI */
        # Author: Newman Sanchez (https://github.com/newmanls) */
        "*" = {
          bg0 = mkLiteral "#212121F2";
          bg1 = mkLiteral "#2A2A2A";
          bg2 = mkLiteral "#3D3D3D80";
          bg3 = mkLiteral "#4CAF50F2";
          fg0 = mkLiteral "#E6E6E6";
          fg1 = mkLiteral "#FFFFFF";
          fg2 = mkLiteral "#969696";
          fg3 = mkLiteral "#3D3D3D";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          spacing = mkLiteral "0px";
        };

        "window" = {
          location = mkLiteral "north";
          y-offset = mkLiteral "calc(50% - 176px)";
          width = 480;
          border-radius = mkLiteral "24px";

          background-color = mkLiteral "@bg0";
        };

        "mainbox" = {
          padding = mkLiteral "12px";
        };

        "inputbar" = {
          background-color = mkLiteral "@bg1";
          border-color = mkLiteral "@bg3";

          border = mkLiteral "2px";
          border-radius = mkLiteral "16px";

          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "8px";
          children = mkLiteral "[ prompt, entry ]";
        };

        "prompt" = {
          text-color = mkLiteral "@fg2";
        };

        "entry" = {
          placeholder = "Search";
          placeholder-color = mkLiteral "@fg3";
        };

        "message" = {
          margin = mkLiteral "12px 0 0";
          border-radius = mkLiteral "16px";
          border-color = mkLiteral "@bg2";
          background-color = mkLiteral "@bg2";
        };

        "textbox" = {
          padding = mkLiteral "8px 24px";
        };

        "listview" = {
          background-color = mkLiteral "transparent";

          margin = mkLiteral "12px 0 0";
          lines = 8;
          columns = 1;

          fixed-height = false;
        };

        "element" = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "8px";
          border-radius = mkLiteral "16px";
        };

        "element normal active" = {
          text-color = mkLiteral "@bg3";
        };

        "element alternate active" = {
          text-color = mkLiteral "@bg3";
        };

        "element selected normal, element selected active" = {
          background-color = mkLiteral "@bg3";
        };

        "element-icon" = {
          size = mkLiteral "1em";
          vertical-align = mkLiteral "0.5";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };
      };
    };

    iconTheme = mkOption {
      type = types.nullOr types.str;
      default = "Papirus-Dark";
    };
  };

  config = lib.mkIf (gui.enable && rofi.enable) {
    programs = {
      rofi = {
        enable = true;
        package = (
        if
          isWayland
        then
          pkgs.rofi-wayland.override {
            plugins = rofi.plugins;
          }
        else
          pkgs.rofi.override {
            plugins = rofi.plugins;
          }
        );
        extraConfig = {
          location = 0;
          yoffset = 0;
          xoffset = 0;
          icon-theme = rofi.iconTheme;
          drun-display-format = "{icon} {name}";
          hide-scrollbar = true;
          display-drun = "  Apps";
          display-run = "  Run";
          display-window = " 󰕰 Window";
          display-Network = " 󰤨 Network";
          display-todo = "  Todo ";
          display-top = " 󰾅 Top ";
          display-filebrowser = "  File Browser";
          display-calc = " 󰪚 Calculator";
          display-emoji = "  Emoji";
          sidebar-mode = true;
          modi = rofi.modi;
          show-icons = true;
          steal-focus = true;
          kb-primary-paste = "Control+V,Shift+Insert";
          kb-secondary-paste = "Control+v,Insert";
        };
        font = "SauceCodePro NFM 16";
        terminal = lib.mkDefault "${pkgs.alacritty}/bin/alacritty";
        theme = rofi.theme;
      };
    };
    home.packages = with pkgs; [
      # A power menu for rofi
      # Shows a Power/Lock menu with Rofi
      # https://github.com/jluttine/rofi-power-menu
      #rofi-power-menu
      # Add `power-menu:rofi-power-menu` to `modi=` to enable

      # Emoji picker - Get a selection of emojis with dmenu or rofi
      # https://github.com/thingsiplay/emojipick
      emojipick

      # Papirus icons to support the default selected
      papirus-icon-theme
    ];
  };
}

## DEFAULT ROFI CONFIGURATION
#configuration {
#      modes: "window,drun,run,ssh";*/
#      font: "mono 12";*/
#        location: 0;
#        yoffset: 0;
#        xoffset: 0;
#      fixed-num-lines: true;*/
#      show-icons: false;*/
#        terminal: "/nix/store/c6yiz6ahjnvgisyzncf7q5l59p2aq4r7-alacritty-0.13.2/bin/alacritty";
#      run-command: "{cmd}";*/
#      run-list-command: "";*/
#      run-shell-command: "{terminal} -e {cmd}";*/
#      drun-match-fields: "name,generic,exec,categories,keywords";*/
#      drun-categories: ;*/
#      drun-show-actions: false;*/
#      drun-display-format: "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";*/
#      drun-url-launcher: "xdg-open";*/
#      disable-history: false;*/
#      ignored-prefixes: "";*/
#      sort: false;*/
#      sorting-method: "normal";*/
#      case-sensitive: false;*/
#      cycle: true;*/
#      sidebar-mode: false;*/
#      hover-select: false;*/
#      eh: 1;*/
#      auto-select: false;*/
#      parse-hosts: false;*/
#      parse-known-hosts: true;*/
#      combi-modes: "window,run";*/
#      matching: "normal";*/
#      tokenize: true;*/
#      m: "-5";*/
#      filter: ;*/
#      dpi: -1;*/
#      threads: 0;*/
#      scroll-method: 0;*/
#      window-format: "{w}    {c}   {t}";*/
#      click-to-exit: true;*/
#      max-history-size: 25;*/
#      combi-hide-mode-prefix: false;*/
#      combi-display-format: "{mode} {text}";*/
#      matching-negate-char: '-' /* unsupported */;*/
#      cache-dir: ;*/
#      window-thumbnail: false;*/
#      drun-use-desktop-cache: false;*/
#      drun-reload-desktop-cache: false;*/
#      normalize-match: false;*/
#      steal-focus: false;*/
#      application-fallback-icon: ;*/
#      refilter-timeout-limit: 8192;*/
#      xserver-i300-workaround: false;*/
#      pid: "/run/user/1000/rofi.pid";*/
#      display-window: ;*/
#      display-windowcd: ;*/
#      display-run: ;*/
#      display-ssh: ;*/
#      display-drun: ;*/
#      display-combi: ;*/
#      display-keys: ;*/
#      display-filebrowser: ;*/
#      kb-primary-paste: "Control+V,Shift+Insert";*/
#      kb-secondary-paste: "Control+v,Insert";*/
#      kb-clear-line: "Control+w";*/
#      kb-move-front: "Control+a";*/
#      kb-move-end: "Control+e";*/
#      kb-move-word-back: "Alt+b,Control+Left";*/
#      kb-move-word-forward: "Alt+f,Control+Right";*/
#      kb-move-char-back: "Left,Control+b";*/
#      kb-move-char-forward: "Right,Control+f";*/
#      kb-remove-word-back: "Control+Alt+h,Control+BackSpace";*/
#      kb-remove-word-forward: "Control+Alt+d";*/
#      kb-remove-char-forward: "Delete,Control+d";*/
#      kb-remove-char-back: "BackSpace,Shift+BackSpace,Control+h";*/
#      kb-remove-to-eol: "Control+k";*/
#      kb-remove-to-sol: "Control+u";*/
#      kb-accept-entry: "Control+j,Control+m,Return,KP_Enter";*/
#      kb-accept-custom: "Control+Return";*/
#      kb-accept-custom-alt: "Control+Shift+Return";*/
#      kb-accept-alt: "Shift+Return";*/
#      kb-delete-entry: "Shift+Delete";*/
#      kb-mode-next: "Shift+Right,Control+Tab";*/
#      kb-mode-previous: "Shift+Left,Control+ISO_Left_Tab";*/
#      kb-mode-complete: "Control+l";*/
#      kb-row-left: "Control+Page_Up";*/
#      kb-row-right: "Control+Page_Down";*/
#      kb-row-up: "Up,Control+p";*/
#      kb-row-down: "Down,Control+n";*/
#      kb-row-tab: "";*/
#      kb-element-next: "Tab";*/
#      kb-element-prev: "ISO_Left_Tab";*/
#      kb-page-prev: "Page_Up";*/
#      kb-page-next: "Page_Down";*/
#      kb-row-first: "Home,KP_Home";*/
#      kb-row-last: "End,KP_End";*/
#      kb-row-select: "Control+space";*/
#      kb-screenshot: "Alt+S";*/
#      kb-ellipsize: "Alt+period";*/
#      kb-toggle-case-sensitivity: "grave,dead_grave";*/
#      kb-toggle-sort: "Alt+grave";*/
#      kb-cancel: "Escape,Control+g,Control+bracketleft";*/
#      kb-custom-1: "Alt+1";*/
#      kb-custom-2: "Alt+2";*/
#      kb-custom-3: "Alt+3";*/
#      kb-custom-4: "Alt+4";*/
#      kb-custom-5: "Alt+5";*/
#      kb-custom-6: "Alt+6";*/
#      kb-custom-7: "Alt+7";*/
#      kb-custom-8: "Alt+8";*/
#      kb-custom-9: "Alt+9";*/
#      kb-custom-10: "Alt+0";*/
#      kb-custom-11: "Alt+exclam";*/
#      kb-custom-12: "Alt+at";*/
#      kb-custom-13: "Alt+numbersign";*/
#      kb-custom-14: "Alt+dollar";*/
#      kb-custom-15: "Alt+percent";*/
#      kb-custom-16: "Alt+dead_circumflex";*/
#      kb-custom-17: "Alt+ampersand";*/
#      kb-custom-18: "Alt+asterisk";*/
#      kb-custom-19: "Alt+parenleft";*/
#      kb-select-1: "Super+1";*/
#      kb-select-2: "Super+2";*/
#      kb-select-3: "Super+3";*/
#      kb-select-4: "Super+4";*/
#      kb-select-5: "Super+5";*/
#      kb-select-6: "Super+6";*/
#      kb-select-7: "Super+7";*/
#      kb-select-8: "Super+8";*/
#      kb-select-9: "Super+9";*/
#      kb-select-10: "Super+0";*/
#      ml-row-left: "ScrollLeft";*/
#      ml-row-right: "ScrollRight";*/
#      ml-row-up: "ScrollUp";*/
#      ml-row-down: "ScrollDown";*/
#      me-select-entry: "MousePrimary";*/
#      me-accept-entry: "MouseDPrimary";*/
#      me-accept-custom: "Control+MouseDPrimary";*/
#  timeout {
#      action: "kb-cancel";
#      delay:  0;
#  }
#  filebrowser {
#      directories-first: true;
#      sorting-method:    "name";
#  }
#}
