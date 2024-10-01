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

  # Defualt for using on Wayland compositors
  programs.nixvim.clipboard = {
    register = "unnamedplus";
    providers.wl-copy = {
      enable = true;
      # wl-clipboard-rs doesn't work in Gnome
      # https://github.com/YaLTeR/wl-clipboard-rs/issues/8#issuecomment-542057210
      package = pkgs.wl-clipboard;
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
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
