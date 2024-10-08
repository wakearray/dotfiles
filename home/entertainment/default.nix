{ config, pkgs, ... }:
{
  home = {
    username = "entertainment";
    homeDirectory = "/home/entertainment";
    stateVersion = "24.05";

    packages = with pkgs; [
      # packages
      firefox-esr
      tidal-hifi
    ];

    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}";
    };
  };

  programs.firefox = {
    enable = true;
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
              name = "Manhwa Recaps";
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
    };
  };
}
