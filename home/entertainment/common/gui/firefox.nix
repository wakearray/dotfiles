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
      bookmarks =
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
              name = "Yuhri";
              url = "https://m.youtube.com/@yuhrixl";
            }
            {
              name = "Manhwa Fresh";
              url = "https://m.youtube.com/@Manhwa_Fresh";
            }
            {
              name = "Nine Tales Recaps";
              url = "https://m.youtube.com/@NineTalesRecaps";
            }
            {
              name = "Mancap";
              url = "https://m.youtube.com/@mancap1";
            }
            {
              name = "Recap-kun";
              url = "https://m.youtube.com/@Recapkun";
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
        {
          name = "ASMR";
          toolbar = true;
          bookmarks = [
            {
              name = "Ann Ann ASMR";
              url = "https://m.youtube.com/@annannasmr";
            }
            {
              name = "Abby ASMR";
              url = "https://m.youtube.com/@AbbyASMR";
            }
          ];
        }
      ];
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
