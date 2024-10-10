{ pkgs, config, ... }:
{
  imports = [
    ./zsh.nix
    ./vscode.nix

    ../../modules/nvim/home.nix
  ];
  home = {
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}/dotfiles";
    };
  };

  programs = {
    # zoxide - A smarter cd command
    # https://github.com/ajeetdsouza/zoxide
    zoxide = {
      enable = true;
      package = pkgs.unstable.zoxide;
    };

    # eza - A modern replacement for ls
    # https://github.com/eza-community/eza
    eza = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs.unstable.eza;
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
