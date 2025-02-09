{ pkgs, ... }:
{
  # /modules/hosts/jerboa
  # imports = [];

  environment.systemPackages = with pkgs; [
    # Music player
    clementine
  ];
}
