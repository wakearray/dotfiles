{ lib, config, ... }:
{
  options.servers.deluge = {
    enable = lib.mkEnableOption "Deluge";

    downloadsDir = lib.mkOption {
      type = lib.types.str;
      default = "/sambazfs/torrents";
      description = "Where you want your torrents downloaded to.";
    };

    webUIPort = lib.mkOption {
      type = lib.types.port;
      default = 8112;
      description = "The port you want to access the webUI on.";
    };

    daemon-port = lib.mkOption {
      type = lib.types.port;
      default = 58846;
      description = "";
    };

    listen-ports = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 6881 6891 ];
      description = "";
    };

    listen-random-port = lib.mkOption {
      type = lib.types.port;
      default = 59413;
      description = "";
    };

    outgoing-ports = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 0 0 ];
      description = "";
    };
  };
  config = lib.mkIf config.servers.deluge.enable {
    services.deluge = {
      enable = config.servers.deluge.enable;
      declarative = true;
      dataDir = "/var/lib/deluge";
      openFirewall = true;
      web = {
        enable = true;
        port = 8112;
        openFirewall = true;
      };
      config = {
        # Attribute set of values from `core.conf` file
        # https://git.deluge-torrent.org/deluge/tree/deluge/core/preferencesmanager.py#n41
        add_paused = false;
        allow_remote = false;
        auto_manage_prefer_seeds = false;
        auto_managed = true;
        cache_expiry = 60;
        cache_size = 512;
        copy_torrent_file = false;
        daemon_port = config.servers.deluge.daemon-port;
        del_copy_torrent_file = false;
        dht = true;
        dont_count_slow_torrents = false;
        download_location = "${config.servers.deluge.downloadsDir}/partial";
        download_location_paths_list = [];
        enabled_plugins = [];
        enc_in_policy = 1;
        enc_level = 2;
        enc_out_policy = 1;
        geoip_db_location = "/usr/share/GeoIP/GeoIP.dat";
        ignore_limits_on_local_network = true;
        info_sent = "0.0";
        listen_interface = "";
        listen_ports = config.servers.deluge.listen-ports;
        listen_random_port = config.servers.deluge.listen-random-port;
        listen_reuse_port = true;
        listen_use_sys_port = false;
        lsd = true;
        max_active_downloading = 3;
        max_active_limit = 8;
        max_active_seeding = 5;
        max_connections_global = 200;
        max_connections_per_second = 20;
        max_connections_per_torrent = -1;
        max_download_speed = "-1.0";
        max_download_speed_per_torrent = -1;
        max_half_open_connections = 50;
        max_upload_slots_global = 4;
        max_upload_slots_per_torrent = -1;
        max_upload_speed = "-1.0";
        max_upload_speed_per_torrent = -1;
        move_completed = false;
        move_completed_path = "${config.servers.deluge.downloadsDir}/completed";
        move_completed_paths_list = [];
        natpmp = true;
        new_release_check = true;
        outgoing_interface = "";
        outgoing_ports = config.servers.deluge.outgoing-ports;
        path_chooser_accelerator_string = "Tab";
        path_chooser_auto_complete_enabled = true;
        path_chooser_max_popup_rows = 20;
        path_chooser_show_chooser_button_on_localhost = true;
        path_chooser_show_hidden_files = false;
        peer_tos = "0x00";
        plugins_location = "${config.services.deluge.dataDir}/.config/deluge/plugins";
        pre_allocate_storage = false;
        prioritize_first_last_pieces = false;
        proxy = {
          anonymous_mode = false;
          force_proxy = false;
          hostname = "";
          password = "";
          port = 8080;
          proxy_hostnames = true;
          proxy_peer_connections = true;
          proxy_tracker_connections = true;
          type = 0;
          username = "";
        };
        queue_new_to_top = false;
        random_outgoing_ports = true;
        random_port = true;
        rate_limit_ip_overhead = true;
        remove_seed_at_ratio = false;
        seed_time_limit = 180;
        seed_time_ratio_limit = "7.0";
        send_info = false;
        sequential_download = false;
        share_ratio_limit = "3.0";
        shared = false;
        stop_seed_at_ratio = false;
        stop_seed_ratio = "3.0";
        super_seeding = true;
        torrentfiles_location = "${config.servers.deluge.downloadsDir}/torrent-files";
        upnp = true;
        utpex = true;
      };
    };
    networking.firewall = let
      ports = [
        config.servers.deluge.daemon-port
        config.servers.deluge.listen-random-port
      ] ++ config.servers.deluge.listen-ports;
    in
    {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
  };
}
