{ domain, ... }:
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./zfs.nix

    ../../servers

    ./systemd-mounts.nix

    ### File
    #./nextcloud.nix
    ./syncthing.nix

    ### Mail
    ./mailserver.nix
  ];

  servers = {
    aria2 = {
      enable = true;
      domain = "aria2.${domain}";
      downloadsDirectory = "/data/downloads/";
    };
    audiobookshelf = {
      enable = true;
      domain = "audiobookshelf.${domain}";
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
      disableRegistration = true;
      mail.enable = false;
      actions.enable = true;
    };
    mail = {
      enable = false;
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
    webdav = {
      enable = true;
      port = 8050;
      sopsFile = ./webdavUsers.yaml;
    };
  };
}
