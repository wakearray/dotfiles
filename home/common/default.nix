{ config, ... }:
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
    zoxide = {
      enable = true;
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
