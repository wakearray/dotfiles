{ domain, ... }:
{
  config = {
    servers = {
      nginx = {
        enable = true;
        domain = domain;
      };
    };
  };
}
