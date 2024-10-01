{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    # gruvbox.nvim - Lua port of the most famous vim colorscheme
    # https://github.com/ellisonleao/gruvbox.nvim/
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

      # nvim-treesitter - Nvim Treesitter configurations and abstraction layer
      # https://github.com/nvim-treesitter/nvim-treesitter
      treesitter.enable = true;

      # wtf - Delicious diagnostic debugging in Neovim
      # https://github.com/piersolenski/wtf.nvim
      wtf.enable = true;

      # rustaceanvim - Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim
      # https://github.com/mrcjkb/rustaceanvim
      rustaceanvim.enable = true;

      # nvim-notify - A fancy, configurable, notification manager for NeoVim
      # https://github.com/rcarriga/nvim-notify
      # Required by rustaceanvim
      notify.enable = true;

      # nvim-dap - Debug Adapter Protocol client implementation for Neovim
      # https://github.com/mfussenegger/nvim-dap
      # Required by rustaceanvim
      dap = {
        enable = true;
        adapters.executables = {
        # Good example https://github.com/foo-dogsquared/nixos-config/blob/8e7a3e6277362d4830b8b13bb8aa02bc7ae5ca6b/configs/home-manager/foo-dogsquared/modules/programs/nixvim/dap.nix#L15
          lldb = {
            command = "lldb-dap";
          };
        };
      };

      # direnv.vim - vim plugin for direnv support
      # https://github.com/direnv/direnv.vim/
      direnv.enable = true;

      # fzf.vim - Improved fzf.vim written in lua
      # https://github.com/ibhagwan/fzf-lua/
      fzf-lua.enable = true;

      # gitignore.nvim - A neovim plugin for generating .gitignore files.
      # https://github.com/wintermute-cell/gitignore.nvim/
      gitignore.enable = true;

      # lualine.nvim - A blazing fast and easy to configure neovim statusline plugin written in pure lua.
      # https://github.com/nvim-lualine/lualine.nvim/
      lualine = {
        enable = true;
        #settings.options.theme = "gruvbox-material";
        # Additional settings:
        # https://nix-community.github.io/nixvim/plugins/lualine/settings/index.html
        # https://github.com/nvim-lualine/lualine.nvim/blob/master/README.md
      };

      # hydra.nvim - Create custom submodes and menus
      # https://github.com/nvimtools/hydra.nvim/
      hydra = {
        enable = true;
        package = pkgs.unstable.vimPlugins.hydra-nvim;
        settings.hint = false;
      };

      # markdown-preview.nvim - markdown preview plugin for (neo)vim
      # https://github.com/iamcco/markdown-preview.nvim/
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
        settings = {
          auto_open = true;
        };
      };

      # nvim-colorizer.lua - The fastest Neovim colorizer. (Highlights color codes)
      # https://github.com/norcalli/nvim-colorizer.lua
      nvim-colorizer.enable = true;

      # qmk.nvim - Format qmk and zmk keymaps in neovim
      # https://github.com/codethread/qmk.nvim/
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

      # parinfer.nvim - A Rust port of parinfer.
      # https://github.com/eraserhd/parinfer-rust
      # Infer parentheses for Clojure, Lisp and Scheme.
      # https://shaunlebron.github.io/parinfer/
      parinfer-rust.enable = true;

      # todo-comments.nvim - Highlight, list and search todo comments in your projects
      # https://github.com/folke/todo-comments.nvim/
      todo-comments.enable = true;

      # intellitab.nvim - A neovim plugin to only press tab once
      # https://github.com/pta2002/intellitab.nvim
      intellitab.enable = true;

      # telescope.nvim - Find, Filter, Preview, Pick. All lua, all the time.
      # https://github.com/nvim-telescope/telescope.nvim/
      telescope.enable = true;

      # vim-gitgutter - A Vim plugin which shows git diff markers in the
      # sign column and stages/previews/undoes hunks and partial hunks.
      # https://github.com/airblade/vim-gitgutter
      gitgutter.enable = true;

      # flash.nvim - Navigate your code with search labels, enhanced
      # character motions and Treesitter integration
      # https://github.com/folke/flash.nvim/
      flash.enable = true;

      # bufferline.nvim - A snazzy bufferline for Neovim
      # https://github.com/akinsho/bufferline.nvim/
      bufferline = {
        enable = true;
#        settings = {
#          options = {
#            diagnostics = "nvim_lsp";
#          };
#        # Lots and lots of settings:
#        # https://nix-community.github.io/nixvim/plugins/bufferline/settings/index.html
#        };
      };

      # vim-floaterm - Terminal manager for (neo)vim
      # https://github.com/voldikss/vim-floaterm
      floaterm = {
        enable = true;
        # Settings: https://nix-community.github.io/nixvim/plugins/floaterm/index.html
      };

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

      # multicursors.nvim - A multi cursor plugin for Neovim.
      # https://github.com/smoka7/multicursors.nvim
      multicursors = {
        enable = true;
        # Many settings: https://nix-community.github.io/nixvim/plugins/multicursors/index.html
      };

      # nvim-spectre - Find the enemy and replace them with dark power.
      # https://github.com/nvim-pack/nvim-spectre/
      spectre = {
        enable = true;
        findPackage = pkgs.repgrep;
        replacePackage = pkgs.gnused;
      };

      # neovim’s built-in LSP
      # https://nix-community.github.io/nixvim/plugins/lsp/index.html
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
}
