{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      # Tridactyl native connector
      tridactyl-native
    ];
    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
    };
    profiles.entertainment = {
      bookmarks = {
        force = true;
        settings =
        [
          {
            name = "YouTube";
            tags = [ "YouTube" ];
            keyword = "YouTube";
            url = "https://www.youtube.com/results?search_query=%s";
          }
          {
            name = "Recaps";
            toolbar = true;
            bookmarks = [
              {
                name = "Manhwa Recaps";
                url = "https://m.youtube.com/@ManhwaRecapsOfficial";
              }
              {
                name = "Manhwa Addict";
                url = "https://m.youtube.com/@ManhwaAddictRecaped";
              }
              {
                name = "Manhwa Recap Zone";
                url = "https://m.youtube.com/@ManhwaRecapZone";
              }
              {
                name = "Anicap";
                url = "https://m.youtube.com/@anicap3468";
              }
              {
                name = "Manhwa Tower";
                url = "https://m.youtube.com/@manhwatower";
              }
              {
                name = "Manhwa Reader";
                url = "https://m.youtube.com/@manhwareader";
              }
            ];
          }
        ];
      };
      #extensions =
      # Search
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "Nix Options" = {
          definedAliases = [ "@no" ];
          urls = [{
            template = "https://search.nixos.org/options";
            params = [
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
        };
        "Nix Wiki" = {
          definedAliases = [ "@nw" ];
          urls = [{
            template = "https://wiki.nixos.org/w/index.php";
            params = [
              { name = "search"; value = "{searchTerms}"; }
            ];
          }];
        };
      };
    };
  };
}
