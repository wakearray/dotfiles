{ ... }:
{
  programs = {
    # yazi - Blazing Fast Terminal File Manager
    # https://github.com/sxyazi/yazi
    yazi = {
      enable = true;
      enableZshIntegration = true;
      initLua = ''
        require("starship"):setup()
      '';
    };
  };
  xdg.configFile = {
    "yazi/plugins/starship.yazi" = {
      source = builtins.fetchGit {
        url = "https://github.com/Rolv-Apneseth/starship.yazi";
        rev = "4053c8c486f9cfd60f1f42fa5d80e97caef41eb1";
      };
    };
  };
}
