{ pkgs, ... }:
{
  ## These are the defaults I want on Moonfish only:
  imports = [
    ./sunshineSteam.nix
  ];

  servers.docker = {
    enable = false;
    gow = {
      wolf = {
        enable = false;
        renderNode = "/dev/dri/renderD128";
        gstDebug = 3;
        rustLog = "INFO";
      };
    };
  };

  sunshineSteam.enable = true;

  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    # For playing audio from one device on another
    soundwireserver

    # utils
    usbutils
    android-tools

    # Audio and video format converter
    ffmpeg_7-full

    # Tool for AMD GPUs
    rocmPackages.rocm-smi
  ];

  virtualisation = {
    virtualbox.host.enable = true;
  };

  boot.supportedFilesystems."fuse.bindfs" = true;
  systemd.mounts = [
    # mount -o X-mount.owner=kent,X-mount.mode=777 -B /home/entertainment/.local/share/Steam/steamapps/ /mnt/shares/steamapps/
    {
      description = "Read-write bind mount for the steamapps folder allowing access by user kent.";
      what = "/home/entertainment/.local/share/Steam/steamapps/";
      where = "/mnt/shares/steamapps/";
      type = "fuse.bindfs";
      options = "force-user=kent,perms=0777";
      wantedBy = [ "multi-user.target" ];
      requires = [ "multi-user.target" ];
    }
  ];
}

