{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Music player
    clementine
  ];
}
