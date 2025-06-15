{ lib, config, ... }:
{
  imports = [
    ./gtklock.nix
  ];

  options.gui.locker = with lib; {
    enable = mkOption {
      type = types.bool;
      default = config.gui.enable;
      description = "Enable the lockscreen.";
    };
  };
}
