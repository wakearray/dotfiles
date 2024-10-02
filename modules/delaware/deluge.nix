{ ... }:
{
  # Deluge
  services.deluge = {
    enable = true;
    declarative = false;
    dataDir = "/mnt/share/downloads";
    openFirewall = true;
    web = {
      enable = true;
      openFirewall = true;
    };
  };
}
