{ domain, pkgs, ... }:
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
        downloadsDirectory = "/data/downloads/";
      };
      audiobookshelf = {
        enable = true;
        localPort = 8066;
      };
      deluge = {
        enable = true;
        webUIPort = 8112;
      };
      docker = {
        enable = true;
        endurain = {
          enable = true;
          localPort = 8060;
          sopsFile = ./endurain.yaml;
        };
        karakeep = {
          enable = true;
          localPort = 8061;
          sopsFile = ./karakeep.yaml;
        };
        tubearchivist = {
          enable = true;
          localPort = 8062;
        };
      };
      forgejo = {
        enable = true;
        domain = domain;
        localPort = 8065;
        disableRegistration = true;
        actions.enable = true;
      };
      nginx.domain = domain;
      paperless = {
        enable = false;
        domain = domain;
        localPort = 28981;
      };
      print.enable = true;
      satisfactory.enable = true;
      webdav = {
        enable = true;
        port = 8050;
        sopsFile = ./webdavUsers.yaml;
      };
    };

    environment.systemPackages = with pkgs; [
      # HDD controls
      hdparm

      # For mounting HDDs using NTFS
      ntfs3g
    ];
  };
}
