{ lib, config, ... }:
let
  cfg = config.home.wm.hyprland;
in
{
  config = {
    home.wm.hyprland = {
      enable = true;
      modKey = "SUPER";
      settings = {
        "$mod" = "${cfg.modKey}";
        "$fileManager" = "${cfg.fileManager}";
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [
          "desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, auto-down, 1.666667"
          ", preferred, auto, 1"
        ];
        plugin = {
          hyprsplit = {
            num_workspaces = 9;
          };
        };
        general = {
          resize_on_border = true;
          layout = "dwindle";
        };
        decoration = {
          rounding = 10;
          blur = {
            enabled = false;
          };
        };
        bind = [
          "$mod      , D    , exec, rofi -show drun"
          "$mod      , A    , exec, [workspace 1] alacritty"
          "$mod      , B    , exec, firefox"
          "          , Print, exec, grimblast copy area"
          "$mod SHIFT, D    , split:swapactiveworkspaces, current +1"
          "$mod SHIFT, G    , split:grabroguewindows"
          "$mod      , Q    , killactive"
          "$mod      , T    , togglefloating"
          "$mod      , F    , fullscreen"
          "$mod      , P    , pin"

          # Exits hyperland
          "$mod SHIFT, Q    , exec, uwsm stop"

          "$mod      , left , movefocus , left"
          "$mod      , right, movefocus , right"
          "$mod      , up   , movefocus , up"
          "$mod      , down , movefocus , down"
          "$mod SHIFT, left , movewindow, left"
          "$mod SHIFT, right, movewindow, right"
          "$mod SHIFT, up   , movewindow, up"
          "$mod SHIFT, down , movewindow, down"

        ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, split:workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
          ])9)
        );
      };
    };
  };
}
