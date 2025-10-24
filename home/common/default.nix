{ outputs, lib, pkgs, config, systemDetails, ... }:
{
  # /home/common
  imports = [
    ./android.nix
    ./gui
    ./shell
    ./ssh.nix
    ./yazi.nix
    ./zellij.nix
    ../../modules/common/nvim/home.nix
  ];

  options.home.systemDetails = with lib; {
    # systemDetails is found and can be edited in each host's configuration in flake.nix
    # It can be overriden in a given host's configuration, but that's not the intended usecase.
    #
    # hostName     = (string of) hostname or home-manager configuration
    # hostType     = (one of) "laptop" "desktop" "server" "android" "kiosk"
    # display      = (one of) "wayland" "x11" "cli"
    # features     = (none, one, or more of) "printers" "installer"
    #                "gaming" "minimal" "developer" "gaming" "eink" "einkColor"
    # architecture = (one of) "x86_64-linux" "aarch64-linux"

    # Hostname
    hostName = mkOption {
      type = types.str;
      default = systemDetails.hostName;
      description = "Set to the host's hostname to make accessing the hostname in scripts easier.";
    };

    # Host Type: [ "laptop" "desktop" "server" "android" "kiosk" ]
    isLaptop = mkOption {
      type = types.bool;
      default = (builtins.match "laptop" systemDetails.hostType != null);
      description = "True if host is a laptop (or laptop like portable).";
    };
    isDesktop = mkOption {
      type = types.bool;
      default = (builtins.match "desktop" systemDetails.hostType != null);
      description = "True if host is a desktop.";
    };
    isServer = mkOption {
      type = types.bool;
      default = (builtins.match "server" systemDetails.hostType != null);
      description = "True if host is a server.";
    };
    isAndroid = mkOption {
      type = types.bool;
      default = (builtins.match "android" systemDetails.hostType != null);
      description = "True if host is Android.";
    };
    isKiosk = mkOption {
      type = types.bool;
      default = (builtins.match "kiosk" systemDetails.hostType != null);
      description = "True if host is intended to be used like a kiosk.";
    };

    # Display [ "wayland" "x11" "cli" ]
    display = {
      wayland = mkOption {
        type = types.bool;
        default = (builtins.match "wayland" systemDetails.display != null);
        description = "True if device uses wayland.";
      };
      x11 = mkOption {
        type = types.bool;
        default = (builtins.match "x11" systemDetails.display != null);
        description = "True if device uses x11.";
      };
      cli = mkOption {
        type = types.bool;
        default = (builtins.match "cli" systemDetails.display != null);
        description = "True if host does not use x11 or wayland.";
      };
    };

    # Features [ "printers" "installer" "minimal" "developer"
    #            "gaming" "eink" "einkColor" ]
    # (`installer` and `printer` options aren't included in home-manager)

    features = {
      minimal = mkOption {
        type = types.bool;
        default = (builtins.match ".*minimal.*" systemDetails.features != null);
        description = "True if derivation needs a minimal build. Mostly for low spec VPS like Hetzner and Oracle.";
      };
      developer = mkOption {
        type = types.bool;
        default = (builtins.match ".*developer.*" systemDetails.features != null);
        description = "True if derivation needs developer tools. A SteamDeck probably doesn't, for instance.";
      };
      gaming = mkOption {
        type = types.bool;
        default = (builtins.match ".*gaming.*" systemDetails.features != null);
        description = "True if derivation needs gaming apps/settings.";
      };
      eink = {
        enable = mkOption {
          type = types.bool;
          default = ((builtins.match ".*eink.*" systemDetails.features != null)||(builtins.match ".*einkColor.*" systemDetails.features != null));
          description = "True if host is eink.";
        };
        Color = mkOption {
          type = types.bool;
          default = (builtins.match ".*einkColor.*" systemDetails.features != null);
          description = "True if host is a color enabled eink device.";
        };
      };
    };


    # Architecture
    architecture = {
      text = mkOption {
        type = types.str;
        default = systemDetails.architecture;
        description = "The text, as a string, of the current host's architecture.";
      };
      isx86_64 = mkOption {
        type = types.bool;
        default = (builtins.match "x86_64-linux" systemDetails.architecture != null);
        description = "True if host is using an x86_64 CPU.";
      };
      isAarch64 = mkOption {
        type = types.bool;
        default = (builtins.match "aarch64-linux" systemDetails.architecture != null);
        description = "True if host is using an aarch64 SOC.";
      };
    };
  };

  config = {
    home = {
      enableNixpkgsReleaseCheck = false;
      sessionVariables = {
        NH_FLAKE = "${config.home.homeDirectory}/dotfiles";
      };
      packages = with pkgs; [
        # socat - Utility for bidirectional data transfer between two independent data channels
        # http://www.dest-unreach.org/socat/
        socat

        # sops - Simple and flexible tool for managing secrets
        # https://github.com/getsops/sops
        sops

        # Lemonade - Remote utility tool that to copy, paste and open browsers over TCP
        # https://github.com/lemonade-command/lemonade/
        lemonade

        # Rust grep use `rg`
        repgrep
        ripgrep
        ripgrep-all

        # Rage - Rust implementation of age
        # https://github.com/str4d/rage
        rage

        # aspell - english spellcheck
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science

        # manix - A fast CLI documentation searcher for Nix
        # https://github.com/nix-community/manix
        manix
      ];
      zellij.enable = true;
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

    # Editor Config helps enforce your preferences on editors
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          trim_trailing_whitespace = true;
          insert_final_newline = true;
          max_line_width = 78;
          indent_style = "space";
          indent_size = 2;
        };
      };
    };

    # Allows home-manager to manage the XDG variables and files
    # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.enable
    xdg = {
      enable = true;
      configHome = "${config.home.homeDirectory}/.config";
    };

    programs = {
      # zoxide - A smarter cd command
      # https://github.com/ajeetdsouza/zoxide
      zoxide = {
        enable = true;
        package = pkgs.zoxide;
      };

      # eza - A modern replacement for ls
      # https://github.com/eza-community/eza
      eza = {
        enable = true;
        package = pkgs.eza;
      };

      home-manager.enable = true;

      # bat - a cat clone with wings written in Rust
      # https://github.com/sharkdp/bat
      # More options found here:
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
      bat.enable = true;

      # btop - Resource monitor that shows usage and stats
      # https://github.com/aristocratos/btop
      # More options found here:
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.btop.enable
      btop.enable = true;

      # fzf - The most supported command line fuzzy finder
      # https://github.com/junegunn/fzf
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      # git
      # More options found here:
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
      git = {
        enable = true;
        settings = {
          color.ui = "auto";
          # initialize new repos using `main` for the first branch rather than `master`
          init.defaultBranch = "main";
        };
        signing = lib.mkDefault {
          format = "ssh";
          signByDefault = true;
        };
        ignores = [
          "*~"
          "*.swp"
        ];
      };

      # delta - A syntax-highlighting pager for git, diff, grep, and blame output
      # https://github.com/dandavison/delta
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      # skim - `sk` - Fuzzy Finder in rust!
      # https://github.com/lotabout/skim
      # More options found here:
      # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.skim.enable
      skim = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
