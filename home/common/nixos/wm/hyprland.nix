{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.home.wm.hyprland;
in
{
  options.home.wm.hyprland = with lib; {
    enable = mkEnableOption "Enable an opinionated hyperland home-manager configuration.";

    fileManager = {
      package = mkOption {
        type = types.package;
        default = pkgs.pcmanfm;
        description = "Set your preferred file manager, as hyperland does not come with one.";
      };
      runCommand = mkOption {
        type = types.str;
        default = "${pkgs.pcmanfm}/bin/pcmanfm";
        description = "The command that is used to open the file manager.";
      };
    };
    modKey = mkOption {
      type = types.enum [ "SUPER" "ALT" "CTRL" ];
      default = "SUPER";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # Disabled due to using UWSM
      # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
      systemd.enable = false;
      settings = {
        "$mod" = "${cfg.modKey}";
        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$fileManager" = "${cfg.fileManager.runCommand}";
        "$menu" = "${pkgs.rofi} --show drun";
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitor = ", preferred, auto, 1";
        bind =
          [
            "$mod, d, exec, $menu"
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
          ] ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i:
                let ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );
      };
      plugins = [
        # hyprgrass - hyprland plugin for touch screen gestures
        # https://github.com/horriblename/hyprgrass
        # inputs.hyprgrass.packages.${pkgs.system}.default

        ## Errors, see notes.
        # hyprsplit - hyprland plugin for separate sets of workspaces on each monitor
        # https://github.com/shezdy/hyprsplit
        inputs.hyprsplit.packages.${pkgs.system}.default

        # hyprspace - Workspace overview plugin for Hyprland
        # https://github.com/KZDKM/Hyprspace
        # inputs.hyprspace.packages.${pkgs.system}.default
      ];
    };
    home.packages = [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      inputs.hyprland-contrib.packages.${pkgs.system}.hdrop
      inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
      inputs.hyprland-contrib.packages.${pkgs.system}.try_swap_workspace
    ];
  };
}
