{ domain, ... }:
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./zfs.nix

    ../../servers

    ### Audio
    ./audiobookshelf.nix

    ### File
    ./nextcloud.nix
    ./syncthing.nix

    ### Git
    ./forgejo.nix

    ### Mail
    ./mailserver.nix
  ];

  servers = {
    deluge.enable = true;
    docker = {
      enable = true;
      lobechat = {
        enable = true;
        domain = "lobe.${domain}";
      };
      tubearchivist.enable = true;
    };
    mail = {
      enable = true;
      domain = "${domain}";
    };
    nginx = {
      enable = true;
      domain = "${domain}";
    };
    satisfactory.enable = true;
    tt-rss = {
      enable = true;
      domain = "rss.${domain}";
    };
    home-assistant.enable = true;
  };
}
