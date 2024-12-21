{ pkgs, ... }:
{
  config = {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        # Tridactyl native connector
        tridactyl-native
      ];
    };
  };
}
