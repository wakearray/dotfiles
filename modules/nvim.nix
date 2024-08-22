{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    globalOpts = {
      # Line numbers
      number = true;
      relativenumber = true;
    };
    plugins = {
      treesitter.enable = true;
      zellij.enable = true;
      wtf.enable = true;
      rustaceanvim.enable = true;
      direnv.enable = true;
      fzf-lua.enable = true;
      gitignore.enable = true;
      lualine.enable = true;
      hydra.enable = false; # Only until border warning is fixed
      markdown-preview = {
        enable = true;
        settings = {
          theme = "dark";
          auto_start = true;
        };
      };
      nvim-colorizer.enable = true;
      qmk = {
        enable = true;
        settings = {
          variant = "zmk";
          layout = [
            "x x"
            "x^x"
          ];
          name = "for zmk this can just be anything, it won’t be used.";
        };
      };
      parinfer-rust.enable = true;
      todo-comments.enable = true;
      intellitab.enable = true;
      telescope.enable = true;
      gitgutter.enable = true;
      flash.enable = true;
      bufferline.enable = true;
      nvim-tree = {
        enable = true;
        openOnSetup = true;
        openOnSetupFile = true;
      };
      multicursors.enable = true;
      spectre = {
        enable = true;
        findPackage = pkgs.repgrep;
        replacePackage = pkgs.gnused;
      };
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            package = pkgs.nixd;
          };
          rust-analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };
          taplo.enable = true;
          marksman.enable = true;
          lua-ls.enable = true;
          bashls.enable = true;
        };
      };
    };
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    # nixd - Nix language server written in C
    # https://github.com/nix-community/nixd
    nixd
    
    gnused
    repgrep
  ];
}
