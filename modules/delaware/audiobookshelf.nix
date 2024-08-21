{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Audiobookshelf
  services.audiobookshelf = {
    enable = true;
    port = 8066;
    package = pkgs.unstable.audiobookshelf;
  };
}
