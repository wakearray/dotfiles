{ outputs,
  pkgs,
  lib,
  ... }:
{
  # A standalone home-manager file for aarch64 Android devices
  # Using either Arch or Debian with the Nix package manager and home-manager

  imports = [
    ./git.nix
    ./gui
  ];

  home.packages = with pkgs; [
    # 7-Zip
    p7zip

    # SSH File System
    sshfs

    # Rust grep use `rg`
    repgrep
    ripgrep
    ripgrep-all

    # Rage - Rust implementation of age
    # https://github.com/str4d/rage
    rage

    # clipboard management
    xclip

    # nh - Yet another nix cli helper
    # https://github.com/viperML/nh/tree/master
    # Use `nh home switch .#kent@mobile` to rebuild home-manager derivation
    nh
  ];

  # Since we're not using NixOS
  targets.genericLinux.enable = true;

  programs = {
    # chrooted Arch in Termux keeps forgetting the path
    zsh.envExtra = ''
PATH=/home/kent/.local/state/nix/profiles/profile/bin:/home/kent/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
    '';
  };

  home.sessionVariables = {
    # This is supposed to resolve an issue with Haskell,
    # but doesn't seem to. Perhaps only an issue on aarch64
    # https://discourse.nixos.org/t/cabal-init-fails-in-devshell/16573
    # https://nixos.org/manual/nixpkgs/stable/#locales
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  home.activation = {
    # Home-Manager frequently kills ssh-agent and
    # causes it to forget its keys
    # So far this only sometimes helps
    activateSshAgent = lib.hm.dag.entryAfter [
      "installPackages"
      "reloadSystemd"
      "checkFilesChanged"
      "onFilesChange"
      "linkGeneration"
    ] ''
      run eval "(/usr/bin/ssh-agent -s)" && \
      /usr/bin/ssh-add $HOME/.ssh/id_ed25519 && \
      /usr/bin/ssh-add $HOME/.ssh/signing_key
    '';
  };

  # nixpkgs allow unfree with unstable overlay.
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
    config = { allowUnfree = true; };
  };
}
