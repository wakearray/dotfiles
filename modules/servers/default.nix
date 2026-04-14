{ ... }:
{
  imports = [
    ./aria2
    ./audiobookshelf.nix
    ./deluge
    ./docker
    ./firewall
    ./forgejo
    ./home-assistant
    ./ldap
    ./jellyfin.nix
    ./mattermost.nix
    ./miniflux.nix
    ./ncps.nix
    ./nginx
    ./ntfy-sh.nix
    ./paperless
    ./printers.nix
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
