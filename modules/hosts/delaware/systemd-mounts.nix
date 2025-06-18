{ ... }:
{
  config = {
    boot.supportedFilesystems."fuse.bindfs" = true;

    systemd.mounts = [
      {
        description = "Read-only bind mount for public webdav access to Audiobooks.";
        what = "/data/audiobooks/";
        where = "/data/userdata/public/Audiobooks/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0444:a+rD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-only bind mount for public webdav access to games.";
        what = "/data/games/";
        where = "/data/userdata/public/Games/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0444:a+rD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-write games bind mount for Kent.";
        what = "/data/games/";
        where = "/data/userdata/Kent/Games/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0664:g+rwD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-write games bind mount for Jess.";
        what = "/data/games/";
        where = "/data/userdata/Jess/Games/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0664:g+rwD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-write audiobooks bind mount for Kent.";
        what = "/data/audiobooks/";
        where = "/data/userdata/Kent/Audiobooks/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0664:g+rwD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-write audiobooks bind mount for Jess.";
        what = "/data/audiobooks/";
        where = "/data/userdata/Jess/Audiobooks/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0664:g+rwD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-write downloads bind mount for Kent.";
        what = "/data/downloads/";
        where = "/data/userdata/Kent/Downloads/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0664:g+rwD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
      {
        description = "Read-write torrents bind mount for Kent.";
        what = "/data/torrents/";
        where = "/data/userdata/Kent/torrents/";
        type = "fuse.bindfs";
        options = "force-user=webdav,force-group=userdata,perms=0664:g+rwD";
        wantedBy = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
      }
    ];
  };
}
