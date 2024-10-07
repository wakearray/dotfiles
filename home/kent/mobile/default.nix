{ outputs, pkgs, ... }:
{
  # A standalone home-manager file for aarch64 Android devices
  # Using either Arch or Debian with the Nix package manager and home-manager
  home.packages = with pkgs; [
    # packages
    firefox-esr
    tidal-hifi
    darktable

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
  ];

  programs = {
    zsh.envExtra = ''
PATH=/home/kent/.local/state/nix/profiles/profile/bin:/home/kent/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
    '';
    git = {
      userName = "Kent Hambrock";
      userEmail = "kent.hambrock@gmail.com";
      extraConfig = {
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg = {
          format = "ssh";
          ssh = {
            allowedSignersFile = "~/.ssh/allowed_signers";
            #program = "/usr/bin/ssh";
          };
        };
        user.signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
      };
    };
  };

  home.file.".ssh/allowed_signers" = {
    text = "kent.hambrock@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
    enable = false;
  };

  # nixpkgs allow unfree with unstable overlay.
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config = { allowUnfree = true; };
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "0: term" = [{ class = "Alacritty"; }];
          "1: discord" = [{ class = "Discord"; }];
          "2: web" = [{ class = "Firefox"; }];
        };
      };
    };
  };
}
