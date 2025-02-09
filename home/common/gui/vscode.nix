{ lib, config, pkgs, ... }:
let
  cfg = config.gui.vscode;
in
{
  options.gui.vscode = with lib; {
    enable = mkEnableOption "Enable and opinionated VSCodium setup";
  };
  config = lib.mkIf (config.gui.enable && cfg.enable) {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ rustup zlib ]);
      enableUpdateCheck = false;
      userSettings = {
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
      ];
    };
  };
}
