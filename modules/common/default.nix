{ pkgs,
  system-details,
  ... }:
{
  imports = [
    ./nvim
    ./printers.nix
    ./spellcheck.nix
    ./ssh.nix
    ./tui.nix
    ./zsh.nix
    ./laptop.nix
  ];

  environment.systemPackages = (
    if
      builtins.match "installer" system-details.host-options != null
    then
      [ pkgs.nixos-install-tools ]
    else
      [ ]
  );
}
