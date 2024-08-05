{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
  secrets = "/etc/nixos/secrets";
  domain = "voicelesscrimson.com";

in
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ZFS boot functionality.
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "ae67779a";
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # Enable ZFS pool (native).
  boot.zfs.extraPools = [ "sambazfs" ];

  # Enable virtualization.
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  networking.hostName = "Delaware"; # Define your hostname.

  # Enable networking.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kent = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "samba" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q kent"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKZDK5hEVMpb35Eanw/7zct8selZTgMtzwak92GdYg0"
    ];
  };

  users.users.sambauser = {
    isNormalUser = true;
    description = "Samba share user";
    extraGroups = [ ];
    packages = with pkgs; [];
  };

  users.users.jess = {
    isNormalUser = true;
    description = "Jess";
    extraGroups = [ "samba" ];
    packages = with pkgs; [];
  };

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

  programs.git = {
    enable = true;
    config = [
      { init = { defaultBranch = "main"; }; }
      { user = {
        name = "Kent Hambrock";
        email = "Kent.Hambrock@gmail.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
      };}
      { gpg = { format = "ssh"; }; }
      { commit = { gpgsign = true; }; }
    ];
  };

  # Environment variables
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Needed for hosting SSH File System
    sshfs

    # Needed for doing things with ZFS
    zfs

    # CUPS supports printing
    cups

    # I don't remember why I put this here. xD
    iproute2

    # Needed for Docker
    bridge-utils
    docker-client
    docker-compose

    # It's git
    git

    # For NextCloud Memories
    exiftool
    # For NextCloud
    php

    # WebUI for Aria2
    unstable.ariang

  ];

  # Docker containers
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      bricks-redis = {
        image = "redis:6.2-alpine";
        cmd = [ "redis-server" "--save" "20" "1" "--loglevel" "warning" "--requirepass" "eYVX7EwVmmxKPCDmwMtyKVge8oLd2t81" ];
        #ports = [ "6379:6379" ];
        volumes = [
          "bricks-redis:/data"
        ];
        hostname = "bricks-redis";
        autoStart = true;
        extraOptions = [ "--network=lobechat-network" ];
      };
      bricks-postgresql = {
        image = "postgres:14.1-alpine";
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
        };
        #ports = [ "5432:5432" ];
        volumes = [
          "bricks-postgresql:/var/lib/postgresql/data"
        ];
        hostname = "bricks-postgresql";
        autoStart = true;
        extraOptions = [ "--network=lobechat-network" ];
      };
      bricksllm = {
        image = "luyuanxin1995/bricksllm";
        cmd = [ "-m=dev" ];
        environment = {
          #OPENAI_API_KEY = "${OPENAI_API_KEY}";
          POSTGRESQL_USERNAME = "postgres";
          POSTGRESQL_PASSWORD = "postgres";
          REDIS_PASSWORD = "eYVX7EwVmmxKPCDmwMtyKVge8oLd2t81";
          POSTGRESQL_HOSTS = "bricks-postgresql";
          REDIS_HOSTS = "bricks-redis";
        };
        ports = [ "8001:8001" "8002:8002" ];
        dependsOn = [ "bricks-redis" "bricks-postgresql" ];
        hostname = "bricksllm";
        autoStart = true;
        extraOptions = [ "--network=lobechat-network" ];
      };
      lobe-chat = {
        image = "lobehub/lobe-chat";
        environment = {
          # Bricksllm locally generated key (accidentally leaked and now invalid)
          # OPENAI_API_KEY = "ebb3a8d1-0fdd-4ccd-a9b1-e5030cebbbfb";
          # Bricksllm local proxy
          OPENAI_PROXY_URL = "http://bricksllm:8002/api/providers/openai/v1";
          CUSTOM_MODELS = "-all,+gpt-3.5-turbo-1106,+gpt-4o=gpt-4o";
        };
        ports = [ "3210:3210" ];
        dependsOn = [ "bricksllm" ];
        hostname = "Lobe-Chat";
        autoStart = true;
        extraOptions = [ "--network=lobechat-network" ];
      };
    };
  };

  # Docker network
  systemd.services.init-lobechat-network = {
    description = "Create the lobechat-network";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
            in ''
              # Put a true at the end to prevent getting non-zero return code, which will
              # crash the whole service.
              check=$(${dockercli} network ls | grep "lobechat-network" || true)
              if [ -z "$check" ]; then
                ${dockercli} network create lobechat-network
              else
                echo "lobechat-network already exists in docker"
              fi
            '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };
  security.pam.sshAgentAuth.enable = true;
  security.pam.services.sudo.sshAgentAuth = true;
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/${domain}";
      };
      "lobe.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:3210";
          };
        };
      };
      "cloud.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "audiobookshelf.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8066";
            proxyWebsockets = true;
          };
        };
      };
      "git.${domain}" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations = {
          "/" = {
            proxyPass = "http://localhost:8065";
          };
        };
      };
    };
  };

  # Forgejo
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.${domain}";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${domain}/";
        PROTOCOL = "https";
        HTTP_PORT = 8065;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration
#       mailer = {
#         ENABLED = true;
#         SMTP_ADDR = "mail.example.com";
#         FROM = "noreply@${srv.DOMAIN}";
#         USER = "noreply@${srv.DOMAIN}";
#       };
    };
#     mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;
  };

  users.users.nginx.extraGroups = [ "acme" ];

  environment.noXlibs = false;
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

  security.acme = {
    acceptTerms = true;
    defaults.email = "kent.hambrock@gmail.com";
  };

  # Audiobookshelf
  services.audiobookshelf = {
    enable = true;
    port = 8066;
    package = pkgs.unstable.audiobookshelf;
  };

  # NextCloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    home = "/sambazfs/nextcloud";
    hostName = "cloud.${domain}";
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
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) bookmarks end_to_end_encryption groupfolders notes notify_push previewgenerator;
    };

    phpOptions = {
      "opcache.interned_strings_buffer" = "23";
      "default_locale" = "en_US";
      "config_is_read_only" = "true";
      "maintenance_window_start" = "10";
    };

    extraAppsEnable = true;
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

  mailserver = {
    enable = true;
    fqdn = "mail.${domain}";
    domains = [ "${domain}" ];

    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
      # this only applies to plain text attachments, binary attachments are never indexed
      indexAttachments = true;
      enforced = "body";
    };

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "admin@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/admin";
        aliases = [ "postmaster@${domain}" "security@${domain}" "abuse@${domain}" ];
      };
      "noreply@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/noreply";
      };
      "kent@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/kent";
      };
      "jess@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/jess";
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };

  # TODO: Setup Rustdesk-Server
#   services.rustdesk-server = {
#     enable = true;
#     openFirewall = true;
#     package = pkgs.unstable.rustdesk-server;
#   };

  # Deluge
  services.deluge = {
    enable = true;
    declarative = false;
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  # Aria2 multithread-multisource downloader
  services.aria2 = {
    enable = true;
    rpcSecretFile = "${secrets}/aria2";
  };

  # Enable CUPS for printer support.
  services.printing = {
    enable = true;
    webInterface = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    drivers = [ pkgs.brlaser ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL-L2300D";
        location = "Chicken Coop";
        deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878K7N171253";
        model = "drv:///brlaser.drv/brl2300d.ppd";
#         ppdOptions = {
#           PageSize = "A4";
#         };
      }
    ];
  };

  # Samba config
  services.samba-wsdd = {
    # make shares visible for Windows clients
    enable = true;
  };
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      load printers = yes
      printing = cups
      printcap name = cups
      obey pam restrictions = yes
      write raw = no
      pam password change = yes
      passwd program = /usr/bin/passwd %u
      server role = standalone server
      os level = 20
      passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
      unix password sync = yes
      locking = no
      workgroup = WORKGROUP
      server string = delaware
      netbios name = delaware
      security = user
      socket options = TCP_NODELAY
      hosts allow = 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      client min protocol = SMB2
    '';
    shares = {
      printers = {
        comment = "All Printers";
        path = "/var/spool/samba";
        public = "yes";
        browseable = "yes";
        "guest ok" = "yes";
        writable = "no";
        printable = "yes";
        "create mode" = 0700;
      };
      Share_Public = {
        "path" = "/mnt/samba/share_public";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" "jess" ];
        "write list" = "kent jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Share_Family = {
        "path" = "/mnt/samba/share_family";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" "jess" ];
        "write list" = "kent jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Share_Friends = {
        "path" = "/mnt/samba/share_friends";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" "jess" ];
        "write list" = "kent jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Personal_Kent = {
        "path" = "/mnt/samba/personal_kent";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" ];
        "write list" = "kent";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Personal_Jess = {
        "path" = "/mnt/samba/personal_jess";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "jess" ];
        "write list" = "jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  # Syncthing, a file syncing service
  services.syncthing = {
    enable = true;
    key = "${secrets}/syncthing/key.pem";
    cert = "${secrets}/syncthing/cert.pem";
    user = "nextcloud";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "Kent_S24_Ultra" = { id = "SD6ZVE2-JPJEKJM-I2VHZBK-A42GUPM-EGIZIG7-QKI3H5B-KG3XEPL-MDETKQZ"; };
        "Kent_P80" = { id = "TUOYN7I-JW7FVCY-B2RJSIW-2QJD6KO-7MQ5JOY-QK5X6HA-BKSZ4KL-FGSVDQL"; };
        "Kent_y700" = { id = "CWTMGYN-7PYXAVX-UVHV2CL-R26FJMJ-GQGOS2B-PBYG4QQ-4562DXH-CEEDUQR"; };
        "Kent_Boox" = { id = "T3U4VSV-7LPWYBK-7GNDAMU-GG7IMXO-OKCFZQB-4WMC2KP-RFANMLH-FFO3WQ7"; };
        "Kent_Hisense_A9" = { id = "S55WSYJ-K3C6MV7-YWEUAW5-YAYHAB2-FIZ7RNR-NE7KCTZ-PZNPO2I-6S3W4AT"; };
        "Kent_GreatBlue" = {
          id = "6B6CFWQ-AOVKOLS-AJ77Y7U-T5G7QPG-IQTPCSJ-NRPZNJR-4LMLIRS-FGMYSQ2";
          autoAcceptFolders = true;
        };
        "Jess_S20_Ultra" = { id = "F436IQN-OOP5KEX-CNCY7VA-4CKUSOR-6YUHIO2-TTESNNW-TMMSMNI-CQZNUAZ"; };
      };
      folders = {
        "Family_Notes" = {         # Name of folder in Syncthing, also the folder ID
          path = "/mnt/syncthing/shared_family/notes";    # Which folder to add to Syncthing
          devices = [
            "Jess_S20_Ultra"
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_GreatBlue"
          ];
        };
        "Kent_Notes" = {
          path = "/mnt/syncthing/kent_personal/notes";
          devices = [
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_GreatBlue"
          ];
        };
        "Kent_DCIM" = {
          path = "/mnt/syncthing/kent_personal/DCIM";
          devices = [ "Kent_S24_Ultra" ];
        };
        "Jess_Notes" = {
          path = "/mnt/syncthing/jess_personal/notes";
          devices = [ "Jess_S20_Ultra" ];
        };
        "Jess_DCIM" = {
          path = "/mnt/syncthing/jess_personal/DCIM";
          devices = [ "Jess_S20_Ultra" ];
        };
      };
    };
  };

  # Required for samba printer sharing
  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
  ];

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
      ExecCondition = "${pkgs.php} -f ${pkgs.nextcloud28}/occ status -e";
      ExecStart = "${pkgs.php} -f ${pkgs.nextcloud28}/cron.php";
      KillMode = "process";
      User = "nextcloud";
    };
  };

  # Docker Container Update Timer
  systemd.services."updateDockerImages" = {
    description = "Pull latest Docker images and restart services";
    script = ''
      #!/bin/sh
      docker pull luyuanxin1995/bricksllm:latest
      docker pull lobehub/lobe-chat:latest
      systemctl restart docker-bricksllm.service
      nix-collect-garbage --delete-older-than 7d
      systemctl restart docker-lobe-chat.service
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  # Define the timer
  systemd.timers.updateDockerImagesTimer = {
    description = "Weekly timer to pull latest Docker images and restart services";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon *-*-* 06:00:00";
      Persistent = true; # Ensures the timer catches up if it missed a run
      Unit = "updateDockerImages.service";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25 80 139 143 445 443 465 587 631 993 3210 8123 8070 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  services.openssh.openFirewall = true;

  system.stateVersion = "23.05";

}
