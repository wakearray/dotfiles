{ pkgs, ... }:
{
  imports = [
    ./nix.nix
  ];

  home.packages = with pkgs; [
    # 7-Zip
    unstable._7zz

    # SSH File System
    sshfs

    # Rust grep use `rg`
    repgrep
    ripgrep
    ripgrep-all

    # Rage - Rust implementation of age
    # https://github.com/str4d/rage
    rage

    # nh - Yet another nix cli helper
    # https://github.com/viperML/nh/tree/master
    # Use `nh home switch .#user@host` to rebuild home-manager derivation
    nh
  ];

  # Since we're not using NixOS
  targets.genericLinux.enable = true;

  # Fixes a haskell error
  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [ "en_US.UTF-8/UTF-8" ];
  };
}
