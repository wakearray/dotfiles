{lib, config, ...}:
{
  options.gui.wm = {};
  config = lib.mkIf (config.host-options.display-system != null) {
    imports = [
      ./gnome.nix
      ./sway.nix
    ];
  };
}
