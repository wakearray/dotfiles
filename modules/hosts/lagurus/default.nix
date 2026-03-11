{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [ vlc ];
  };
}
