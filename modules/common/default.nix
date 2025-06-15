{ pkgs, systemDetails, ... }:
{
  imports = [
    ./nvim
    ./printers.nix
    ./spellcheck.nix
    ./ssh.nix
    ./syncthing.nix
    ./tui.nix
    ./zsh.nix
    ./laptop.nix
  ];

  environment.systemPackages = (
    if
      builtins.match "installer" systemDetails.features != null
    then
      [ pkgs.nixos-install-tools ]
    else
      [ ]
  );
}
