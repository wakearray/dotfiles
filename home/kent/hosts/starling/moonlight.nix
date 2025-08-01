{ lib, config, pkgs, ... }:

{
  config = {
    home.packages = [
      # Moonlight client
      pkgs.moonlight-qt
    ];
  };
}
