{ ... }:
{
  home = {
    username = "kent";
    homeDirectory = "/home/kent";
    stateVersion = "24.05";
  };

  imports = [
    ../common

    ./git.nix
    ./starship.nix
    ./zellij.nix
    ./ssh.nix
    ./fonts.nix
  ];

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
}
