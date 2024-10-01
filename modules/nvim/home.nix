{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  imports = [
    ./nixvim.nix
  ];

  programs.nixvim.clipboard = {
    register = "unnamedplus";
    providers.xclip.enable = true;
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      # nixd - Nix language server written in C
      # https://github.com/nix-community/nixd
      nixd

      # CodeLLDB - A debugging server for Rust
      # https://github.com/vadimcn/codelldb
      vscode-extensions.vadimcn.vscode-lldb

      lldb_18

      gnused
      repgrep
    ];
  };
}
