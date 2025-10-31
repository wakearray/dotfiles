{ domain, ... }:
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./zfs.nix

    ./systemd-mounts.nix

    ./syncthing.nix
  ];

  config = {
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
        tubearchivist.enable = true;
      };
      forgejo = {
        enable = true;
        domain = "${domain}";
        localPort = 8065;
        disableRegistration = true;
        actions.enable = true;
      };
      ncps = {
        enable = true;
        storageLocation = "/mnt/ssd980/ncps";
      };
      nginx = {
        enable = true;
        rootURL.enable = false;
      };
      paperless = {
        enable = true;
        domain = "paperless.${domain}";
        port = 28981;
      };
      print.enable = true;
      satisfactory.enable = true;
      webdav = {
        enable = true;
        port = 8050;
        sopsFile = ./webdavUsers.yaml;
      };
    };
  };
}
