{ ... }:
{
  # yazi - Blazing Fast Terminal File Manager
  # https://github.com/sxyazi/yazi

  imports = [ ./flavor.nix ];

  config = {
    programs = {
      yazi = {
        enable = true;
        enableZshIntegration = true;
        initLua = ''
          require("starship"):setup()
        '';
      };
    };

    xdg.configFile = {
      # Starship.yazi plugin
      "yazi/plugins/starship.yazi" = {
        source = builtins.fetchGit {
          url = "https://github.com/Rolv-Apneseth/starship.yazi";
          rev = "6fde3b2d9dc9a12c14588eb85cf4964e619842e6";
        };
      };
    };
  };
}
