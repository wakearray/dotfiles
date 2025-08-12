{ config, lib, pkgs, ... }:
let
  hasWayland = config.modules.systemDetails.display.wayland;
  isDeveloper = config.modules.systemDetails.features.developer;
in
{
  imports = [
    ./nixvim-devel.nix
    ./nixvim-minimal.nix
  ];

  # Defualt for using on Wayland compositors
  programs.nixvim.clipboard.providers.wl-copy.enable = hasWayland;

  environment.variables = {
    EDITOR = "nvim --listen /tmp/nvim-socket-$(uuidgen)";
  };
  environment.systemPackages = lib.mkIf isDeveloper [
    # nixd - Nix language server written in C
    # https://github.com/nix-community/nixd
    pkgs.nixd

    # CodeLLDB - A debugging server for Rust
    # https://github.com/vadimcn/codelldb
    pkgs.vscode-extensions.vadimcn.vscode-lldb

    pkgs.lldb_18

    pkgs.gnused
    pkgs.repgrep
  ];
}
