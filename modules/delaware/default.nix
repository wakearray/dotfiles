{ ... }:
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./printers.nix
    #./rustdesk.nix
    ./systemd-mounts.nix
    ./zfs.nix

    ## Servers

    ./nginx.nix

    ### Audio
    ./audiobookshelf.nix
    ./jellyfin.nix

    ### Docker
    ../server/docker/lobechat.nix
    ../server/docker/wger.nix

    ### File
    ./deluge.nix
    ./nextcloud.nix
    ./samba.nix
    ./syncthing.nix

    ### Git
    ./forgejo.nix

    ### Mail
    ./mailserver.nix

    ### RSS
    ./tt-rss.nix

    ### Game servers
    ./satisfactory.nix
  ];

  # Where needed:
  # {secrets, domain, ...}:
  # {
  #   secrets = "/etc/nixos/secrets";
  #   domain = "voicelesscrimson.com";
  # }

  services.satisfactory = { enable = true; };
}
