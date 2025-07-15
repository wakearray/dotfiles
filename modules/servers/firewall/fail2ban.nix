{ lib, config, ... }:
let
  f2b = config.servers.firewall.fail2ban;
in
{
  options.servers.firewall.fail2ban = with lib; {
    enable = mkEnableOption "Enable an opinionated fail2ban configuration.";
  };

  config = lib.mkIf f2b.enable {
    services.fail2ban = {
      enable = true;
     # Ban IP after 5 failures
      maxretry = 5;
      ignoreIP = [
        # Whitelist some subnets
        "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"

        # Cloudflare IP Ranges
        "103.21.244.0/22"
        "103.22.200.0/22"
        "103.31.4.0/22"
        "104.16.0.0/13"
        "104.24.0.0/14"
        "108.162.192.0/18"
        "131.0.72.0/22"
        "141.101.64.0/18"
        "162.158.0.0/15"
        "172.64.0.0/13"
        "173.245.48.0/20"
        "188.114.96.0/20"
        "190.93.240.0/20"
        "197.234.240.0/22"
        "198.41.128.0/17"
        # IPv6
        "2400:cb00::/32"
        "2606:4700::/32"
        "2803:f800::/32"
        "2405:b500::/32"
        "2405:8100::/32"
        "2a06:98c0::/29"
        "2c0f:f248::/32"

        "8.8.8.8" # whitelist a specific IP
      ];
      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "8760h"; # Do not ban for more than 1 year
        overalljails = true; # Calculate the bantime based on all the violations
      };
      jails = {
        apache-nohome-iptables.settings = {
          # Block an IP address if it accesses a non-existent
          # home directory more than 5 times in 10 minutes,
          # since that indicates that it's scanning.
          filter = "apache-nohome";
          action = ''iptables-multiport[name=HTTP, port="http,https"]'';
          logpath = "/var/log/httpd/error_log*";
          backend = "auto";
          findtime = 600;
          bantime  = 600;
          maxretry = 5;
        };
        nginx-url-probe.settings = {
          enabled = true;
          filter = "nginx-url-probe";
          logpath = "/var/log/nginx/access.log";
          action = ''%(action_)s[blocktype=DROP]
                   ntfy'';
          backend = "auto"; # Do not forget to specify this if your jail uses a log file
          maxretry = 5;
          findtime = 600;
        };
      };
    };

    environment.etc = {
      # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
      "fail2ban/action.d/ntfy.local".text = lib.mkDefault (lib.mkAfter ''
        [Definition]
        norestored = true # Needed to avoid receiving a new notification after every restart
        actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/Fail2banNotifications
      '');
      # Defines a filter that detects URL probing by reading the Nginx access log
      "fail2ban/filter.d/nginx-url-probe.local".text = lib.mkDefault (lib.mkAfter ''
        [Definition]
        failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
      '');
    };
  };
}
