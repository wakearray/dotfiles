{ ... }:
{
  imports = [
    ./audiobookshelf.nix
    ./docker
    ./deluge
    ./home-assistant
    ./satisfactory.nix
    ./tt-rss.nix
    ./nginx.nix
    ./jellyfin.nix
  ];
}
