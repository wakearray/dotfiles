{ ... }:
{
  imports = [
    ./aria2
    ./audiobookshelf.nix
    ./docker
    ./deluge
    ./firewall
    ./home-assistant
    ./satisfactory.nix
    ./tt-rss.nix
    ./nginx.nix
    ./jellyfin.nix
    ./webdav.nix
  ];
}
