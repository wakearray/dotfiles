{ lib, config, pkgs, outputs, ... }:
let
  isAndroid = config.home.systemDetails.isAndroid;
  user = config.home.username;
in
{
  # home/common/android
  # All settings should pertain to non-gui related options and packages
  config = lib.mkIf isAndroid {
    home = {
      # On NixOS profiles, these packages should be installed at the system level
      packages = with pkgs; [
        # 7-Zip
        _7zz

        # SSH File System
        sshfs

        # nh - Yet another nix cli helper
        # https://github.com/viperML/nh/tree/master
        # Use `nh home switch .#user@host` to rebuild home-manager derivation
        nh
      ];
    };

    # On Android in `chroot` environments `/sys/class/power_supply` contains `battery`
    gui.eww.battery.identifier = lib.mkDefault "battery";

    # Since we're not using NixOS
    targets.genericLinux.enable = true;

    # Fixes a haskell error
    i18n.glibcLocales = pkgs.glibcLocales.override {
      allLocales = false;
      locales = [ "en_US.UTF-8/UTF-8" ];
    };

    programs = {
      # chrooted Arch in Termux keeps forgetting the path
      zsh.envExtra = "PATH=/home/${user}/.local/bin:/home/${user}/.local/state/nix/profiles/profile/bin:/home/${user}/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/bin";
    };

    # nixpkgs allow unfree with stable overlay.
    nixpkgs = {
      overlays = [
        outputs.overlays.stable-packages
        outputs.overlays.modifications
        outputs.overlays.additions
        #outputs.overlays.nur-packages
      ];
      config = { allowUnfree = true; };
    };

    nix = {
      package = pkgs.lixPackageSets.latest.lix;
      # Weekly garbage collection
      gc = {
        automatic = true;
        frequency = "weekly";
      };

      # The contents of the nix.conf file
      # Some settings will be needed when installing/using Nix on Android
      # Not needed when using lix
      #
      # settings = {
      #   experimental-features = [ "nix-command" "flakes" ];
      #   accept-flake-config = true;
      #   auto-optimise-store = true;
      #   fallback = true;
      #   max-jobs = "auto";
      #   download-buffer-size = 268435456;
      # };
    };
  };
}
