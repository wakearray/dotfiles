{ ... }:
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./systemd-mounts.nix
    ./zfs.nix

    ../../servers

    ### Audio
    ./audiobookshelf.nix

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