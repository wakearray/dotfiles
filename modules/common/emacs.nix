{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (
      (emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (
        epkgs: [ epkgs.vterm ]
    ))
  ];
}
