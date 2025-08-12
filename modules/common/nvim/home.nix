{ lib, config, pkgs, ... }:
let
  isAndroid = config.home.systemDetails.isAndroid;
  isDeveloper = config.home.systemDetails.features.developer;
  hasWayland = config.home.systemDetails.display.wayland;
in
{
  imports = [
    ./nixvim-minimal.nix
    ./nixvim-devel.nix
    ./markdown-oxide.nix
  ];

  config = {
    developer.nixvim.enable = isDeveloper;

    programs.nixvim.clipboard.providers.xclip.enable = isAndroid;
    programs.nixvim.clipboard.providers.wl-copy.enable = hasWayland;

    home = lib.mkIf isAndroid {
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
  };
}
