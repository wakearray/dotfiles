{ pkgs,
  host-options,
  ... }:
{
  imports = [
    ./nvim
    #./emacs.nix
    (if builtins.match "printers" host-options != null then ./printers.nix else null)
    ./ssh.nix
    ./tui.nix
    ./zsh.nix
  ];

  environment.systemPackages = [
    (if builtins.match "installer" host-options != null then pkgs.nixos-install-tools else null)
  ];
}
