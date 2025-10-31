{ config, lib, pkgs, ... }:
let
  cfg = config.servers.mattermost;
in
{
  options.servers.mattermost = with lib; {
    enable = mkEnableOption "Enable an opinionated Mattermost config.";

    domain = mkOption {
      type = types.str;
      default = "chat.example.com";
      description = "Subdomain and domain of the hosted instance.";
    };

    localPort = mkOption {
      type = types.port;
      default = 8065;
      description = "Port of the webserver.";
    };

    siteName = mkOption {
      type = types.str;
      default = "Mattermost";
      description = "Name of the website hosting this instance.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mattermost = {
        enable = true;
        package = pkgs.mattermostLatest;
        siteName = cfg.siteName;
        siteUrl = "https://${cfg.domain}";
        port = cfg.localPort;
        mutableConfig = true;
        socket = {
          enable = true;
          path = "/var/lib/mattermost/mattermost.sock";
        };
        plugins = with pkgs; [
          # Hide Spoilers
          # 0.1.0
          # https://github.com/svelle/mattermost-spoiler-plugin
          (fetchurl {
            url = "https://github.com/svelle/mattermost-spoiler-plugin/releases/download/0.1.0/com.svelle.mattermost-spoiler-plugin-0.1.0.tar.gz";
            hash = "sha256-TbzMNRocUt5j8bYc9Hd0+vJ0htWi7fsqf/dOzSBe4aU=";
          })

          # Giphy/Tenor Support
          # 4.0.0
          # https://github.com/moussetc/mattermost-plugin-giphy
          (fetchurl {
            url = "https://github.com/moussetc/mattermost-plugin-giphy/releases/download/v4.0.0/com.github.moussetc.mattermost.plugin.giphy-4.0.0.tar.gz";
            hash = "sha256-Eq1ynuZl7bdUWlVZMgEEB6z2mxG6dR5Rx6432R+2vY8=";
          })

          # Meme Generator
          # 1.5.0
          # https://github.com/mattermost-community/mattermost-plugin-memes/tree/master
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-memes/releases/download/v1.5.0/memes-1.5.0.tar.gz";
            hash = "";
          })

          # RemindMe Bot
          # 1.0.0
          # https://github.com/scottleedavis/mattermost-plugin-remind/blob/master/README.md
          (fetchurl {
            url = "https://github.com/scottleedavis/mattermost-plugin-remind/releases/download/v1.0.0/com.github.scottleedavis.mattermost-plugin-remind-1.0.0.tar.gz";
            hash = "";
          })

          # Todo
          # 0.7.1
          # https://github.com/mattermost-community/mattermost-plugin-todo
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-todo/releases/download/v0.7.1/com.mattermost.plugin-todo-0.7.1.tar.gz";
            hash = "";
          })

          # Auto Markdown Links
          # 1.4.1
          # https://github.com/mattermost-community/mattermost-plugin-autolink
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-autolink/releases/download/v1.4.1/mattermost-autolink-1.4.1.tar.gz";
            hash = "";
          })

          # ClamAV - Auto scan uploads for viruses
          # 1.0.0
          # https://github.com/mattermost-community/mattermost-plugin-antivirus#installation
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-antivirus/releases/download/v1.0.0/antivirus-1.0.0.tar.gz";
            hash = "";
          })

          # Replace - sed style comment editing
          # 0.2.0
          # https://github.com/carmo-evan/mattermost-plugin-replace
          (fetchurl {
            url = "https://github.com/carmo-evan/mattermost-plugin-replace/releases/download/v0.2.1/com.mattermost.replace-0.2.0.tar.gz";
            hash = "";
          })

          # Draw - Let usrs draw simple art inside Mattermost
          # 0.0.4
          # https://github.com/jespino/mattermost-plugin-draw
          (fetchurl {
            url = "https://github.com/jespino/mattermost-plugin-draw/releases/download/v0.0.4/com.mattermost.draw-plugin-0.0.4.tar.gz";
            hash = "";
          })

          # Walltime - shows message time in user's time zone
          # 0.1.1
          # https://github.com/mattermost-community/mattermost-plugin-walltime
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-walltime/releases/download/0.1.1/com.mattermost.walltime-plugin-0.1.1.tar.gz";
            hash = "";
          })

          # Agents - LLM integration for Mattermost
          # 1.5.0
          # https://github.com/mattermost/mattermost-plugin-agents
          (fetchurl {
            url = "https://github.com/mattermost/mattermost-plugin-agents/releases/download/v1.5.0/mattermost-plugin-agents-v1.5.0-linux-amd64.tar.gz";
            hash = "sha256:83ad8d2833657d0405b926dacd7a42a500e090b97f370d82c7f5bf925c42b802";
          })

          # Custom Attributes - Add additional attributes to members
          # 1.3.1
          # https://github.com/mattermost-community/mattermost-plugin-custom-attributes
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-custom-attributes/releases/download/v1.3.1/com.mattermost.custom-attributes-1.3.1.tar.gz";
            hash = "";
          })

          # Matterpoll - Polls for Mattermost
          # 1.8.0
          # https://github.com/matterpoll/matterpoll
          (fetchurl {
            url = "https://github.com/matterpoll/matterpoll/releases/download/v1.8.0/com.github.matterpoll.matterpoll-1.8.0.tar.gz";
            hash = "";
          })

          # Freemium - Remove Mattermost ads and references to bbeing a free/community server
          # 1.8.0
          # https://github.com/dy0gu/mattermost-plugin-freemium
          (fetchurl {
            url = "https://github.com/dy0gu/mattermost-plugin-freemium/releases/download/v1.8.0/freemium.tar.gz";
            hash = "";
          })

          #
          #
          # https://github.com/streamer45/mattermost-plugin-voice
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/mattermost-community/mattermost-plugin-agenda
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/gabrieljackson/mattermost-plugin-wrangler
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/quarkslab/mattermost-plugin-e2ee
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/crspeller/mattermost-plugin-channel-notes
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/jfrerich/mattermost-plugin-bookmarks
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/mattermost/mattermost-plugin-community
          (fetchurl {
            url = "";
            hash = "";
          })

          #
          #
          # https://github.com/streamer45/mattermost-plugin-screen
          (fetchurl {
            url = "";
            hash = "";
          })

          # Bot Webhook
          # 0.3.0
          # https://github.com/timkley/mattermost-plugin-bot-webhook
          (fetchurl {
            url = "https://github.com/timkley/mattermost-plugin-bot-webhook/releases/download/v0.3.0/bot-webhook-plugin-0.3.0.tar.gz";
            hash = "";
          })

          # Github
          # 2.5.0
          # https://github.com/mattermost/mattermost-plugin-github
          (fetchurl {
            url = "https://github.com/mattermost/mattermost-plugin-github/releases/download/v2.5.0/mattermost-plugin-github-v2.5.0-linux-amd64.tar.gz";
            hash = "";
          })

          # Jitsi - Self hosted video conferencing plugin
          # 2.1.0
          # https://github.com/mattermost-community/mattermost-plugin-jitsi
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-jitsi/releases/download/v2.1.0/jitsi-2.1.0.tar.gz";
            hash = "";
          })

          # Forgejo plugin
          # TODO: It needs to be compiled
          # https://github.com/hhru/mattermost-plugin-forgejo
#          (fetchurl {
#            url = "";
#            hash = "";
#          })

          # Mermaid - Support for Mermaidjs in Mattermost
          # TODO: Needs compilation
          # https://github.com/SpikeTings/Mermaid
#          (fetchurl {
#            url = "";
#            hash = "";
#          })

          #
          #
          #
          (fetchurl {
            url = "";
            hash = "";
          })
        ];
      };

      # Nginx reverse proxy
      nginx.virtualHosts."${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          client_max_body_size 105M;
        '';
        locations."/" = {
          proxyPass = "http://localhost:${builtins.toString cfg.localPort}";
          proxyWebsockets = true;
        };
      };
    };

    environment.systemPackages = [ pkgs.mmctl ];
  };
}
