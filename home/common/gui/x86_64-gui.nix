{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    # LocalSend - Cross-platform FOSS replacement for Airdrop
    # https://github.com/localsend/localsend
    # Port 53317 needs too be opened
    localsend
  ];
}
