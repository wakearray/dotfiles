{ pkgs,
  system-details,
  ... }:
{
  imports = [
    ./nvim
    (if builtins.match "printers" system-details.host-options != null then ./printers.nix else null)
    ./spellcheck.nix
    ./ssh.nix
    ./tui.nix
    ./zsh.nix
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
