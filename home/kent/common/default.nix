{ system-details, ... }:
{
  imports = [
    ./git.nix
    ./zellij.nix
    (if builtins.match "none" system-details.display-type != null then ./headless.nix else ./gui)
  ];
}
