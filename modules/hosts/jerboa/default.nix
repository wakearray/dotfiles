{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Music player
    unstable.clementine
  ];
}
