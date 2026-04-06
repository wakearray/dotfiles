{ ... }:
{
  config = {
    servers.lldap = {
      enable = true;
      domain = "voicelesscrimson.com";
      sopsFile = ./lldap.yaml;
    };
  };
}
