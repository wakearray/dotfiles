{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  vscode = gui.vscode;
in
{
  options.gui.vscode = with lib; {
    enable = mkEnableOption "Enable and opinionated VSCodium setup";

    profiles = mkOption {
      type = types.attrs;
      default = {
        default = {
          enableExtensionUpdateCheck = true;
          enableUpdateCheck = false;
          extensions = with pkgs.vscode-extensions; [
            vscodevim.vim
            yzhang.markdown-all-in-one
            vlanguage.vscode-vlang
            vadimcn.vscode-lldb
            tamasfe.even-better-toml
            rust-lang.rust-analyzer
            rubymaniac.vscode-paste-and-indent
            ms-vsliveshare.vsliveshare
          ];
          globalSnippets = {
            fixme = {
              body = [
                "$LINE_COMMENT FIXME: $0"
              ];
              description = "Insert a FIXME remark";
              prefix = [
                "fixme"
              ];
            };
          };
          keybindings = [
            {
              key = "ctrl+c";
              command = "editor.action.clipboardCopyAction";
              when = "textInputFocus";
            }
          ];
          languageSnippets = {
            haskell = {
              fixme = {
                body = [
                  "$LINE_COMMENT FIXME: $0"
                ];
                description = "Insert a FIXME remark";
                prefix = [
                  "fixme"
                ];
              };
            };
          };
          userSettings = {
            "[nix]"."editor.tabSize" = 2;
          };
          userTasks = {
            version = "2.0.0";
            tasks = [
              {
                type = "shell";
                label = "Hello task";
                command = "hello";
              }
            ];
          };
        };
      };
      description = "An attribute set of attribute sets of users and their settings. Documentation can be found here: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles";
    };
  };
  config = lib.mkIf (gui.enable && vscode.enable) {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ rustup zlib ]);
      enableUpdateCheck = false;
      profiles = vscode.profiles;
    };
  };
}
