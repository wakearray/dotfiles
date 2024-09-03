{lib, pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ rustup zlib ]);    userSettings = {
      "[nix]"."editor.tabSize" = 2;
    };
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      yzhang.markdown-all-in-one
      vlanguage.vscode-vlang
      vadimcn.vscode-lldb
      tamasfe.even-better-toml
      rust-lang.rust-analyzer
      rubymaniac.vscode-paste-and-indent
      ms-vsliveshare.vsliveshare
      jdinhlife.gruvbox
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
  };
}
