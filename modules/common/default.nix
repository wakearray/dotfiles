{ pkgs, config, ... }:
{
  imports = [
    ./nvim
    ./emacs.nix
    (if config.host-options.hasPrinters then ./printers.nix else null)
    ./ssh.nix
    ./tui.nix
    ./zsh.nix
  ];

  environment.systemPackages = [
    (if config.host-options.canInstall then pkgs.nixos-install-tools else null)
  ];
}
