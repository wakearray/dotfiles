{ ... }:
{
  imports = [
    ./home-assistant.nix
  ];

  config = {
    servers.nginx = {
      enable = true;
      rootURL.enable = false;
    };
  };
}
