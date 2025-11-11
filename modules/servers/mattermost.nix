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
            hash = "sha256-c+OW/Sfc1cipBulaoik412ig3khR9EhNQ5UJe0NNq2U=";
          })

          # RemindMe Bot
          # 1.0.0
          # https://github.com/scottleedavis/mattermost-plugin-remind/blob/master/README.md
          (fetchurl {
            url = "https://github.com/scottleedavis/mattermost-plugin-remind/releases/download/v1.0.0/com.github.scottleedavis.mattermost-plugin-remind-1.0.0.tar.gz";
            hash = "sha256-uFH4w6xROC4uG+5fHY342A2Rr9bvkJyKxBGfyE7L63I=";
          })

          # Todo
          # 0.7.1
          # https://github.com/mattermost-community/mattermost-plugin-todo
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-todo/releases/download/v0.7.1/com.mattermost.plugin-todo-0.7.1.tar.gz";
            hash = "sha256-P+Z66vqE7FRmc2kTZw9FyU5YdLLbVlcJf11QCbfeJ84=";
          })

          # Auto Markdown Links
          # 1.4.1
          # https://github.com/mattermost-community/mattermost-plugin-autolink
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-autolink/releases/download/v1.4.1/mattermost-autolink-1.4.1.tar.gz";
            hash = "sha256-uKnGAGO9CQquBLWcehhUeNOIMZduKmYL2hhDEpmUTlE=";
          })

          # ClamAV - Auto scan uploads for viruses
          # 1.0.0
          # https://github.com/mattermost-community/mattermost-plugin-antivirus#installation
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-antivirus/releases/download/v1.0.0/antivirus-1.0.0.tar.gz";
            hash = "sha256-Hc4kVhDcFZ3KbvlSBbYy6yhaNwvp2fduCL0gC1XG2mo=";
          })

          # Replace - sed style comment editing
          # 0.2.0
          # https://github.com/carmo-evan/mattermost-plugin-replace
          (fetchurl {
            url = "https://github.com/carmo-evan/mattermost-plugin-replace/releases/download/v0.2.1/com.mattermost.replace-0.2.0.tar.gz";
            hash = "sha256-Ue7X8uc9sqxEbzTsmbrXxV/TXFZtdcCoTuE1iYmIwog=";
          })

          # Draw - Let usrs draw simple art inside Mattermost
          # 0.0.4
          # https://github.com/jespino/mattermost-plugin-draw
          (fetchurl {
            url = "https://github.com/jespino/mattermost-plugin-draw/releases/download/v0.0.4/com.mattermost.draw-plugin-0.0.4.tar.gz";
            hash = "sha256-Vl0x01ZKhWVz9Fw11UD55xgUEfTPP+Jp0J9vhtf8zb4=";
          })

          # Walltime - shows message time in user's time zone
          # 0.1.1
          # https://github.com/mattermost-community/mattermost-plugin-walltime
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-walltime/releases/download/0.1.1/com.mattermost.walltime-plugin-0.1.1.tar.gz";
            hash = "sha256-4etbmpjakDeM9M17LXoXvHu2IQO4Run3mmqOyog2l0Y=";
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
            hash = "sha256-+vlbd++EEMJV0L9FixUShBua8YMF/K9QLq8fC5szq10=";
          })

          # Matterpoll - Polls for Mattermost
          # 1.8.0
          # https://github.com/matterpoll/matterpoll
          (fetchurl {
            url = "https://github.com/matterpoll/matterpoll/releases/download/v1.8.0/com.github.matterpoll.matterpoll-1.8.0.tar.gz";
            hash = "sha256-ORfa+f5HJLbG+kRnL+UnbL66iPH+S9jhOHdB1vvRx2A=";
          })

          # Freemium - Remove Mattermost ads and references to bbeing a free/community server
          # 1.8.0
          # https://github.com/dy0gu/mattermost-plugin-freemium
          (fetchurl {
            url = "https://github.com/dy0gu/mattermost-plugin-freemium/releases/download/v1.8.0/freemium.tar.gz";
            hash = "sha256-teHhqQqG6PYkSoz3nZBFi39tyEJ3MoyQWPWHOpOPJ/I=";
          })

          # Meeting Agenda plugin
          # 0.2.3
          # https://github.com/mattermost-community/mattermost-plugin-agenda
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-agenda/releases/download/v0.2.3/com.mattermost.agenda-0.2.3.tar.gz";
            hash = "sha256-7LyK2z7Y1chBHXoL5MXLtc0yj28plQyOPkdO3fwtSEU=";
          })

          # Message Wrangler - Lets you move messages between threads and channels
          # 0.9.0
          # https://github.com/gabrieljackson/mattermost-plugin-wrangler
          (fetchurl {
            url = "https://github.com/gabrieljackson/mattermost-plugin-wrangler/releases/download/v0.9.0/com.mattermost.wrangler-0.9.0.tar.gz";
            hash = "sha256-S1DzEy9z69TqLeEa8X4MDkxW5IIyGvTTxLDBZu8Yeko=";
          })

          # End2EndEncryption using PGP keys
          # 0.9.1
          # https://github.com/quarkslab/mattermost-plugin-e2ee
          (fetchurl {
            url = "https://github.com/quarkslab/mattermost-plugin-e2ee/releases/download/v0.9.1/com.quarkslab.e2ee-0.9.1.tar.gz";
            hash = "sha256-oczKNgV55gwS/pijreq+5KpkKmtzx+UuJKUjFk8461Q=";
          })

          # Channel Notes
          # 0.1.1
          # https://github.com/crspeller/mattermost-plugin-channel-notes
          (fetchurl {
            url = "https://github.com/crspeller/mattermost-plugin-channel-notes/releases/download/v0.1.1/channel-notes-0.1.1.tar.gz";
            hash = "sha256-GwjMAUlcxJDoGqZNEvUqRsI7xo8LDRAXCFzAPw/ohhs=";
          })

          # Bot Webhook
          # 0.3.0
          # https://github.com/timkley/mattermost-plugin-bot-webhook
          (fetchurl {
            url = "https://github.com/timkley/mattermost-plugin-bot-webhook/releases/download/v0.3.0/bot-webhook-plugin-0.3.0.tar.gz";
            hash = "sha256-8J7RFmwMYyEcPfqQlzHR+KQ8yXhoAHvBWAfFiWh9wUU=";
          })

          # Github
          # 2.5.0
          # https://github.com/mattermost/mattermost-plugin-github
          (fetchurl {
            url = "https://github.com/mattermost/mattermost-plugin-github/releases/download/v2.5.0/mattermost-plugin-github-v2.5.0-linux-amd64.tar.gz";
            hash = "sha256-NsQ0DrZOXx1G2H5IoE8D6XtRnFwBjIYX2q/q36V3uLQ=";
          })

          # Jitsi - Self hosted video conferencing plugin
          # 2.1.0
          # https://github.com/mattermost-community/mattermost-plugin-jitsi
          (fetchurl {
            url = "https://github.com/mattermost-community/mattermost-plugin-jitsi/releases/download/v2.1.0/jitsi-2.1.0.tar.gz";
            hash = "sha256-c7l9LzQRRAtEiG03uZgn9V8NowFBx3s+xiuPwuC9HeQ=";
          })

          # Voice Message plugin
          # TODO: Needs more work to fix compilation errors
          # https://github.com/streamer45/mattermost-plugin-voice
          #(mattermost.buildPlugin {
          # pname = "mattermost-plugin-voice";
          # version = "";
          # src = fetchFromGitHub {
          #   owner = "streamer45";
          #   repo = "mattermost-plugin-voice";
          #   rev = "421c4ece43fcad86701d6ffaca86c150c7b1a2b4";
          #   hash = "sha256-B44BQqREVod7dxxQtmhILVyu8Kr+/VqJEogclguruLQ=";
          # };
          # vendorHash = "sha256-zPhwWhLs19BxoB3EOPpKWaAFHE5zjU0m/3R1lAmYzX0=";
          # npmDepsHash = "sha256-cDgx0BpFttFUTfmOUrMwpc8QIOS753CLm/GfbzjepJE=";
          # extraGoModuleAttrs = {
          #   npmFlags = [ "--legacy-peer-deps" ];
          # };
          #)

          # Forgejo plugin
          # TODO: Needs more work to fix compilation errors
          # https://github.com/hhru/mattermost-plugin-forgejo
          #(mattermost.buildPlugin {
          # pname = "mattermost-plugin-forgejo";
          # version = "";
          # src = fetchFromGitHub {
          #   owner = "hhru";
          #   repo = "mattermost-plugin-forgejo";
          #   rev = "1a77c36638cadbfa6cbc911f8fccbdd6bf1861ee";
          #   hash = "sha256-rdcgm+HmfMXYllV3kOwfOxuEdnYdAa+k6kP8Rx7FipM=";
          # };
          # vendorHash = "sha256-eQNke8ISodQJriKhzGi+TawMBidMZ89ltR9NwwkHOxo=";
          # npmDepsHash = "sha256-6WXZe74/YO9ppwBV4CFB6yIfkCkrS00AtzVBjMvbyoQ=";
          # extraGoModuleAttrs = {
          #   npmFlags = [ "--legacy-peer-deps" ];
          # };
          #})

          # Mermaid - Support for Mermaidjs in Mattermost
          # TODO: Needs compilation
          # https://github.com/SpikeTings/Mermaid
          #(mattermost.buildPlugin {
          # pname = "Mermaid";
          # version = "";
          # src = fetchFromGitHub {
          #   owner = "SpikeTings";
          #   repo = "Mermaid";
          #   rev = "6e3d7e0b6e0f82ef8d214e195e32a4be2441773d";
          #   hash = "";
          # };
          # vendorHash = "";
          # npmDepsHash = "";
          # extraGoModuleAttrs = {
          #   npmFlags = [ "--legacy-peer-deps" ];
          # };
          #})

          # Message Bookmarks
          # TODO: Needs compilation
          # https://github.com/jfrerich/mattermost-plugin-bookmarks
          #(mattermost.buildPlugin {
          # pname = "mattermost-plugin-bookmarks";
          # version = "";
          # src = fetchFromGitHub {
          #   owner = "jfrerich";
          #   repo = "mattermost-plugin-bookmarks";
          #   rev = "";
          #   hash = "";
          # };
          # vendorHash = "";
          # npmDepsHash = "";
          # extraGoModuleAttrs = {
          #   npmFlags = [ "--legacy-peer-deps" ];
          # };
          #})

          # GitHub Community plugin
          # TODO: Needs compilation
          # https://github.com/mattermost/mattermost-plugin-community
          #(mattermost.buildPlugin {
          # pname = "mattermost-plugin-community";
          # version = "";
          # src = fetchFromGitHub {
          #   owner = "mattermost";
          #   repo = "mattermost-plugin-community";
          #   rev = "";
          #   hash = "";
          # };
          # vendorHash = "";
          # npmDepsHash = "";
          # extraGoModuleAttrs = {
          #   npmFlags = [ "--legacy-peer-deps" ];
          # };
          #})

          # Screen Recorder plugin
          # TODO: Needs compilation
          # https://github.com/streamer45/mattermost-plugin-screen
          #(mattermost.buildPlugin {
          # pname = "mattermost-plugin-screen";
          # version = "";
          # src = fetchFromGitHub {
          #   owner = "streamer45";
          #   repo = "mattermost-plugin-screen";
          #   rev = "";
          #   hash = "";
          # };
          # vendorHash = "";
          # npmDepsHash = "";
          # extraGoModuleAttrs = {
          #   npmFlags = [ "--legacy-peer-deps" ];
          # };
          #})
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
