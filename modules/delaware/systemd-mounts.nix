{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # I need to reorganize the server file structure so that 
  # some of these folders are outside the NextCloud folder 
  # structure and are mounted inside NextCloud as 
  # "external storage"

  systemd.mounts = [
    { # Create a `mount --bind` of the audiobooks folder so Audiobookshelf can still access it.
      description = "Bind mount for Audiobookshelf";
      what = "/sambazfs/nextcloud/data/__groupfolders/4/Audio Books/";
      where = "/var/lib/audiobookshelf/audiobooks";
      options = "bind,username=audiobookshelf";
      wantedBy = [ "local-fs.target" ];
      requires = [ "local-fs.target" ];
    }
    {# Create a `mount --bind` of the personal and group NextCloud folders so samba can still access them.
      description = "Public share bind mount for samba";
      what = "/sambazfs/nextcloud/data/__groupfolders/2/";
      where = "/mnt/samba/share_public";
      options = "bind,username=nextcloud";
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
