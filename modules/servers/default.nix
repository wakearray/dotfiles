{ ... }:
{
  imports = [
    ./docker
    ./deluge
    ./satisfactory.nix
    ./tt-rss.nix
    ./nginx.nix
    ./jellyfin.nix
  ];
}
