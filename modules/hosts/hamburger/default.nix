{ domain, ... }:
{

  config = {
    servers = {
      nginx = {
        enable = true;
        domain = domain;
      };
      mail = {
        enable = true;
        domain = domain;
      };
    };
  };
}
