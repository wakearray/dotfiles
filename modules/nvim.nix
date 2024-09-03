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
      shiftwidth = 2;
    };
    extraConfigLuaPre = ''
  -- Hide depreciation warnings
  vim.notify = function(msg, ...)
    if msg:match("has been deprecated") then
      return
      end
    notify(msg, ...)
  end
'';
    plugins = {
      treesitter.enable = true;
      zellij.enable = true;
      wtf.enable = true;
      rustaceanvim.enable = true;
      dap = { 
        enable = true; 
        adapters.executables = {
        # Good example https://github.com/foo-dogsquared/nixos-config/blob/8e7a3e6277362d4830b8b13bb8aa02bc7ae5ca6b/configs/home-manager/foo-dogsquared/modules/programs/nixvim/dap.nix#L15
          lldb = {
            command = "lldb-dap";
          };
        };
      };
      direnv.enable = true;
      fzf-lua.enable = true;
      gitignore.enable = true;
      lualine.enable = true;
     #hydra.enable = false; # Only until border warning is fixed
      markdown-preview = {
        enable = true;
        settings = {
          theme = "dark";
          auto_start = true;
        };
      };
      # Trouble - Shows lsp errors
      # https://github.com/folke/trouble.nvim
      trouble = { 
        enable = true;
        # Settings found here:
        # https://nix-community.github.io/nixvim/plugins/trouble/settings/index.html
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
      # nvim-tree - A file explorer tree for nvim
      # https://github.com/nvim-tree/nvim-tree.lua
      # 
      # Common commands:
      # :NvimTreeToggle   | Opens and closes the navigation tree
      # :NvimTreeFocus    | Open and focus on tree
      # :NvimTreeFindFile | Move cursor to requested file
      # :NvimTreeCollapse | Collapse the tree recursively
      nvim-tree = {
        enable = true;
        openOnSetup = true;
        openOnSetupFile = true;
      };
      # Removed till hydra warning is fixed:
      # https://github.com/nix-community/nixvim/issues/1943
      #multicursors.enable = true;

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

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
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
