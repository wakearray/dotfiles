{ ... }:
{
  imports = [
    ./aria2
    ./audiobookshelf.nix
    ./docker
    ./deluge
    ./firewall
    ./forgejo.nix
    ./home-assistant
    ./satisfactory.nix
    ./tt-rss.nix
    ./nginx.nix
    ./jellyfin.nix
    ./webdav.nix
  ];
}
