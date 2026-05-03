{ ... }:
{
  imports = [
    ./aria2
    ./audiobookshelf.nix
    ./deluge
    ./docker
    ./firewall
    ./forgejo
    ./idP
    ./jellyfin.nix
    ./mattermost.nix
    ./miniflux.nix
    ./ncps.nix
    ./nginx
    ./paperless
    ./printers.nix
    ./remoteLUKSUnlock.nix
    ./satisfactory.nix
    ./webdav.nix
  ];

  config = {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "kent.hambrock@gmail.com";
      };
    };
  };
}
