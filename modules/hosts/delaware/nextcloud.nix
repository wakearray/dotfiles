{ lib, pkgs, domain, ... }:
{
  environment.systemPackages = with pkgs; [
    # For NextCloud Memories
    exiftool
    # For NextCloud
    php
  ];

  services.postgresql = {
    enable = true;

    # Ensure the database, user, and permissions always exist
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
     {
       name = "nextcloud";
       ensureDBOwnership = true;
     }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  # NextCloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    home = "/sambazfs/nextcloud";
    hostName = "cloud.${domain}";
    autoUpdateApps.enable = true;
    nginx.hstsMaxAge = 15552000;
    config = {
      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      dbpassFile = "/var/nextcloud-db-pass";

      adminpassFile = "/var/nextcloud-admin-pass";
      adminuser = "admin";
    };
    appstoreEnable = true;

    phpOptions = {
      "opcache.interned_strings_buffer" = "23";
      "default_locale" = "en_US";
      "config_is_read_only" = "true";
      "maintenance_window_start" = "10";
    };

    settings = {
      loglevel = 2;
      log_type = "file";

      # Further forces Nextcloud to use HTTPS
      overwriteprotocol = "https";

      default_phone_region = "US";
      # Fixes ffmpeg errors
      "memories.vod.ffmpeg" = "${lib.getExe pkgs.ffmpeg-headless}";
      "memories.vod.ffprobe" = "${pkgs.ffmpeg-headless}/bin/ffprobe";
      "memories.exiftool" = "${pkgs.exiftool}/bin/exiftool";
      "memories.exiftool_no_local" = true;
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
        "OS\\Preview\\Videos"
      ];
    };
  };

  # NextCloud Cron service
  systemd.timers."nextcloudcron" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "nextcloudcron.service";
    };
  };

  systemd.services."nextcloudcron" = {
    serviceConfig = {
      ExecCondition = "${pkgs.php} -f ${pkgs.nextcloud30}/occ status -e";
      ExecStart = "${pkgs.php} -f ${pkgs.nextcloud30}/cron.php";
      KillMode = "process";
      User = "nextcloud";
    };
  };

  # Nginx reverse proxy
  services.nginx.virtualHosts = {
    "cloud.${domain}" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
