{ ... }:
{
  # Everything exclusive to Shoebill
  imports = [
    ./git.nix

    # SteamOS frontend
    ./jovian.nix
  ];

  gui = {
    enable = true;
    _1pass.enable = true;
    syncthing = {
      enable = true;
      user = "jess";
      sopsFile = ./syncthing.yaml;
    };
    print.enable = true;
    wm.gnome.enable = true;
  };
}
