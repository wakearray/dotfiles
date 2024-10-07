{ ... }:
let

in
{
  imports = [
    ./zsh.nix
    ./vscode.nix

    ../../modules/nvim/home.nix
  ];
  home.enableNixpkgsReleaseCheck = false;

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
