{ ... }:
{
  systemd.mounts = [
    {
      description = "Read-only bind mount for public webdav access to Audiobooks";
      what = "/data/audiobooks/";
      where = "/data/userdata/public/audiobooks";
      options = "bind,noatime,username=webdav";
      mountConfig = {
        DirectoryMode = "444";
      };
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Family share bind mount for samba";
      what = "/sambazfs/nextcloud/data/__groupfolders/3/";
      where = "/mnt/samba/share_family";
      options = "bind,username=nextcloud";
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Friends share bind mount for samba";
      what = "/sambazfs/nextcloud/data/__groupfolders/4/";
      where = "/mnt/samba/share_friends";
      options = "bind,username=nextcloud";
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Kent personal storage bind mount for samba";
      what = "/sambazfs/nextcloud/data/Kent/files";
      where = "/mnt/samba/personal_kent";
      options = "bind,username=nextcloud";
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {
      description = "Jess personal storage bind mount for samba";
      what = "/sambazfs/nextcloud/data/Jess/files";
      where = "/mnt/samba/personal_jess";
      options = "bind,username=nextcloud";
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
  ];
}
