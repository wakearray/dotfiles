{ pkgs, ... }:
{
  # Audiobookshelf
  services.audiobookshelf = {
    enable = true;
    port = 8066;
    package = pkgs.unstable.audiobookshelf;
  };
}
