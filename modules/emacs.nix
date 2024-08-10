{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = [
    (
      (emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (
        epkgs: [ epkgs.vterm ]
    ))
  ];
}
