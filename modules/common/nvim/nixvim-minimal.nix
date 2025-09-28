{ lib, ... }:
{
  # The minimum Nixvim config, especially for use on servers
  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";
    colorschemes.base16 = {
      enable = true;
      colorscheme = lib.mkDefault "gruvbox-material-dark-medium";
    };
    globalOpts = lib.mkDefault {
      # Line numbers
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    # keymaps
    keymaps = [
      {
        action = "<CMD>bprevious<CR>";
        key = "<M-S-Left>";
        mode = [ "n" "v" "i" ];
        options = {
          desc = "Switch to previous buffer";
          silent = true;
        };
      }
      {
        action = "<CMD>bnext<CR>";
        key = "<M-S-Right>";
        mode = [ "n" "v" "i" ];
        options = {
          desc = "Switch to next buffer";
          silent = true;
        };
      }
      {
        action = "<CMD>noh<CR>";
        key = "<M-Space>";
        mode = [ "n" "v" "i" ];
        options = {
          desc = "Clear highlighting";
          silent = true;
        };
      }
      {
        action = "<CMD>Telescope<CR>";
        key = "<M-t>";
        mode = [ "n" "i" ];
        options = {
          desc = "Open Telescope";
          silent = true;
        };
      }
      {
        action = "<CMD>Telescope live_grep<CR>";
        key = "<M-g>";
        mode = [ "n" "i" ];
        options = {
          desc = "Open Telescope live_grep";
          silent = true;
        };
      }
      {
        action = "<CMD>Telescope buffers<CR>";
        key = "<M-b>";
        mode = [ "n" "i" ];
        options = {
          desc = "Open Telescope buffers";
          silent = true;
        };
      }
      {
        action = "<CMD>NvimTreeToggle<CR>";
        key = "<M-t>";
        mode = [ "n" "i" ];
        options = {
          desc = "Toggle Neovim Tree";
          silent = true;
        };
      }
    ];

    # plugins
    plugins = {
      # Dependency of many other plugins
      web-devicons.enable = true;

      # lualine.nvim - A blazing fast and easy to configure
      # neovim statusline plugin written in pure lua.
      # https://github.com/nvim-lualine/lualine.nvim/
      lualine = {
        enable = true;
        # settings.options.theme = lib.mkDefault "gruvbox-material";
        # Additional settings:
        # https://nix-community.github.io/nixvim/plugins/lualine/settings/index.html
        # https://github.com/nvim-lualine/lualine.nvim/blob/master/README.md
      };

      # intellitab.nvim - A neovim plugin to only press tab once
      # https://github.com/pta2002/intellitab.nvim
      intellitab.enable = true;

      # telescope.nvim - Find, Filter, Preview, Pick. All lua, all the time.
      # https://github.com/nvim-telescope/telescope.nvim/
      telescope.enable = true;

      # bufferline.nvim - A snazzy bufferline for Neovim
      # https://github.com/akinsho/bufferline.nvim/
      bufferline = {
        enable = true;
        settings.options = {
          diagnostics = "nvim_lsp";
          numbers = {
            __raw = ''
              function(opts)
                return string.format('%s|%s', opts.id, opts.raise(opts.ordinal))
              end
            '';
          # Lots and lots of settings:
          # https://nix-community.github.io/nixvim/plugins/bufferline/settings/index.html
          };
        };
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

      # which-key.nvim - helps you remember your Neovim keymaps,
      # by showing available keybindings in a popup as you type.
      # https://github.com/folke/which-key.nvim
      which-key = {
        enable = true;
        # More settings here:
        # https://nix-community.github.io/nixvim/plugins/which-key/index.html
      };
    };
  };
}

