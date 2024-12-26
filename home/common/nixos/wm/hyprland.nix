{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.home.wm.hyprland;
in
{
  options.home.wm.hyprland = with lib; {
    enable = mkEnableOption "Enable an opinionated hyperland home-manager configuration.";

    modKey = mkOption {
      type = types.enum [ "SHIFT" "CAPS" "CTRL" "ALT" "SUPER" ];
      default = "SUPER";
    };
    settings = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # Disabled due to using UWSM
      # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
      systemd.enable = false;
      settings = cfg.settings;
      plugins = [
        # hyprgrass - hyprland plugin for touch screen gestures
        # https://github.com/horriblename/hyprgrass
        # inputs.hyprgrass.packages.${pkgs.system}.default

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
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      pkgs.glm
    ];
  };
}
