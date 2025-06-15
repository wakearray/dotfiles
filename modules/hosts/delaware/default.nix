{ domain, ... }:
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./zfs.nix

    ../../servers

    ### Audio
    #./audiobookshelf.nix

    ### File
    #./nextcloud.nix
    ./syncthing.nix

    ### Git
    ./forgejo.nix

    ### Mail
    ./mailserver.nix
  ];

  servers = {
    aria2 = {
      enable = true;
      downloadsDirectory = "/data/downloads/";
    };
    audiobookshelf = {
      enable = true;
      domain = "${domain}";
    };
    deluge.enable = true;
    docker = {
      enable = true;
      lobechat = {
        enable = true;
        domain = "lobe.${domain}";
      };
      tubearchivist.enable = true;
    };
    forgejo = {
      enable = true;
      domain = "${domain}";
      localPort = 8065;
      mail.enable = false;
      actions.enable = false;
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
  };
}
