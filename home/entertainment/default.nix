{ config, ... }:
let
  user = config.home.username;
in
{
  imports = [
    ./common
    ../common
  ];

  home = {
    username = "entertainment";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
  };
}
