{ config, lib, pkgs, ... }:
let
  cfg = config.gui.firefox;
in
{
  options.gui.firefox = with lib; {
    enable = mkEnableOption "Enable an opinionated Firefox config with Tridactyl enabled.";
  };

  config = lib.mkIf (config.gui.enable && cfg.enable) {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        # Tridactyl native connector
        tridactyl-native
      ];
#      profiles = {
#        default = {
#          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
#            #
#            #
#            # https://augmentedsteam.com/
#            augmented-steam
#
#            # https://gitlab.com/ivanruvalcaba/BehindTheOverlayRevival
#            behind-the-overlay-revival
#
#            # https://bitwarden.com/
#            bitwarden
#
#            # https://github.com/brandon1024/find/
#            brandon1024-find
#
#            # https://censortracker.org/en.html
#            censor-tracker
#
#            # https://docs.clearurls.xyz/1.26.1/
#            clearurls
#
#            # https://consentomatic.au.dk/
#            consent-o-matic
#
#            # https://github.com/menhera-org/TabArray
#            container-tab-groups
#
#            # https://github.com/0x6b/copy-selection-as-markdown
#            copy-selection-as-markdown
#
#            # https://darkreader.org/
#            darkreader
#
#            # https://dearrow.ajay.app/
#            dearrow
#
#            # https://github.com/softvar/enhanced-github
#            enhanced-github
#
#            # https://www.mrfdev.com/enhancer-for-youtube
#            enhancer-for-youtube
#
#            # https://github.com/alct/export-tabs-urls
#            export-tabs-urls-and-titles
#
#            # https://addons.mozilla.org/en-US/firefox/addon/gruvbox-dark-theme/
#            gruvbox-dark-theme
#
#            # https://hoarder.app/
#            hoarder
#
#            # https://www.joinhoney.com/
#            honey
#
#            # https://github.com/hoppscotch/hoppscotch-extension
#            hoppscotch
#
#            # https://www.i-dont-care-about-cookies.eu/
#            i-dont-care-about-cookies
#
#            # https://github.com/Baldomo/open-in-mpv
#            iina-open-in-mpv
#
#            # https://www.localcdn.org/
#            localcdn
#
#            # https://github.com/musically-ut/lovely-forks
#            lovely-forks
#
#            # https://github.com/deathau/markdownload
#            markdownload
#
#            # https://git.sr.ht/~tomf/one-click-wayback
#            one-click-wayback
#
#            # https://1password.com/
#            onepassword-password-manager
#
#            # https://github.com/refined-github/refined-github
#            refined-github
#
#            # https://returnyoutubedislike.com/
#            return-youtube-dislikes
#
#            # https://sponsor.ajay.app/
#            sponsorblock
#
#            # https://steamdb.info/
#            steam-database
#
#            # https://github.com/Loirooriol/tab-counter-plus
#            tab-counter-plus
#
#            # https://tab-session-manager.sienori.com/
#            tab-session-manager
#
#            # https://github.com/Mika-/torrent-control
#            torrent-control
#
#            # https://github.com/ushnisha/tranquility-reader-webextensions
#            tranquility-1
#
#            # https://github.com/FilipePS/Traduzir-paginas-web
#            translate-web-pages
#
#            # https://github.com/tubearchivist/browser-extension
#            tubearchivist-companion
#
#            # https://github.com/gorhill/uBlock#ublock-origin
#            ublock-origin
#          ];
#        };
#      };
    };
  };
}
