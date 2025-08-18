{ domain, ... }:
{
  config = {
    servers = {
      nginx = {
        enable = false;
        domain = domain;
      };
    };
  };
}
