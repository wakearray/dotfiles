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
    ../servers
    ./nginx.nix

    ### Audio
    ./audiobookshelf.nix
    # ./jellyfin.nix

    ### File
    ./nextcloud.nix
    ./samba.nix
    ./syncthing.nix

    ### Git
    ./forgejo.nix

    ### Mail
    ./mailserver.nix
  ];

  # Where needed:
  # {secrets, domain, ...}:
  # {
  #   secrets = "/etc/nixos/secrets";
  #   domain = "voicelesscrimson.com";
  # }

  host-options = {
    display-system = "none";
    host-type = "server";
  };

  servers = {
    deluge.enable = true;
    docker = {
      enable = true;
      lobechat.enable = true;
      tubearchivist.enable = true;
    };
    satisfactory.enable = true;
    tt-rss = {
      enable = true;
    };
  };
}
