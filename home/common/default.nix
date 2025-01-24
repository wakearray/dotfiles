{ pkgs, config, system-details, ... }:
{
  # /home/common
  imports = [
    ./zsh.nix
    ./ssh.nix
    (
      if
        builtins.match "android" system-details.host-type != null
      then
        ./android
      else
        ./nixos
    )
    ./gui
    ../../modules/common/nvim/home.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}/dotfiles";
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
      enableZshIntegration = true;
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
      # delta - A syntax-highlighting pager for git, diff, grep, and blame output
      # https://github.com/dandavison/delta
      delta.enable = true;
    };

    # skim - `sk` - Fuzzy Finder in rust!
    # https://github.com/lotabout/skim
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.skim.enable
    skim = {
      enable = true;
      enableZshIntegration = true;
    };

    # yazi - Blazing Fast Terminal File Manager
    # https://github.com/sxyazi/yazi
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
