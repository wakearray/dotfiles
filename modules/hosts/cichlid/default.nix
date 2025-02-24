{ ... }:
{
  # Things only for Cichlid
  imports = [
    # Harware related
    ./nvidia.nix
    ./rgb.nix

    # Software related
    ./git.nix
  ];

  gui = {
    enable = true;
    _1pass.enable = true;
    syncthing = {
      enable = true;
      user = "jess";
      sopsFile = ./syncthing.yaml;
    };
    gaming.enable = true;
    wm.gnome.enable = true;
  };
}
