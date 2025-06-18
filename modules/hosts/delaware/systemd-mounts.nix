{ ... }:
{
  systemd.mounts = [
    {
      description = "Read-only bind mount for public webdav access to Audiobooks.";
      what = "/data/audiobooks/";
      where = "/data/userdata/public/audiobooks/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "444";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Read-only bind mount for public webdav access to games.";
      what = "/data/games/";
      where = "/data/userdata/public/games/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "444";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Read-write games bind mount for Kent.";
      what = "/data/games/";
      where = "/data/userdata/Kent/games/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "664";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Read-write games bind mount for Jess.";
      what = "/data/games/";
      where = "/data/userdata/Jess/games/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "664";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Read-write audiobooks bind mount for Kent.";
      what = "/data/audiobooks/";
      where = "/data/userdata/Kent/audiobooks/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "664";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Read-write audiobooks bind mount for Jess.";
      what = "/data/audiobooks/";
      where = "/data/userdata/Jess/audiobooks/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "664";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Read-write downloads bind mount for Kent.";
      what = "/data/downloads/";
      where = "/data/userdata/Kent/downloads/";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "664";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
  ];
}
