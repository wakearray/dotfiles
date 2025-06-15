{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    # gruvbox.nvim - Lua port of the most famous vim colorscheme
    # https://github.com/ellisonleao/gruvbox.nvim/
    colorschemes.base16 = {
      enable = true;
      colorscheme = "gruvbox-material-dark-medium";
    };
    dependencies = {
      gcc.enable = true;
    };
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
  end
'';
    # keymaps
    keymaps = [
      {
        action = "<esc>:bp";
        key = "<M-J>";
        mode = [ "n" "v" "i" ];
        options = {
          desc = "Switch to previous buffer";
          silent = true;
        };
      }
      {
        action = "<esc>:bn";
        key = "<M-K>";
        mode = [ "n" "v" "i" ];
        options = {
          desc = "Switch to next buffer";
          silent = true;
        };
      }
      {
        action = "<esc>:noh";
        key = "<M-Space>";
        mode = [ "n" "v" "i" ];
        options = {
          desc = "Clear highlighting";
          silent = true;
        };
      }
      {
        action = "<esc>:Telescope";
        key = "<M-t>";
        mode = [ "n" "i" ];
        options = {
          desc = "Open Telescope";
          silent = true;
        };
      }
      {
        action = "<esc>:Telescope live_grep";
        key = "<M-g>";
        mode = [ "n" "i" ];
        options = {
          desc = "Open Telescope live_grep";
          silent = true;
        };
      }
      {
        action = "<esc>:Telescope buffers";
        key = "<M-b>";
        mode = [ "n" "i" ];
        options = {
          desc = "Open Telescope buffers";
          silent = true;
        };
      }
    ];

    # plugins
    plugins = {
      # Dependency of many other plugins
      web-devicons.enable = true;

      # nvim-treesitter - Nvim Treesitter configurations and abstraction layer
      # https://github.com/nvim-treesitter/nvim-treesitter
      treesitter = {
        enable = true;
        autoLoad = true;
        # Settings:
        # https://nix-community.github.io/nixvim/plugins/treesitter/settings/index.html
        settings = {
          auto_install = true;
          ensure_installed = "all";
          highlight = {
            enable = true;
          };
        };
      };

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
        settings.options.theme = "gruvbox-material";
        # Additional settings:
        # https://nix-community.github.io/nixvim/plugins/lualine/settings/index.html
        # https://github.com/nvim-lualine/lualine.nvim/blob/master/README.md
      };

#      # hydra.nvim - Create custom submodes and menus
#      # https://github.com/nvimtools/hydra.nvim/
#      hydra = {
#        enable = true;
#        package = pkgs.vimPlugins.hydra-nvim;
#        settings.hint = false;
#      };

      # markdown-preview.nvim - markdown preview plugin for (neo)vim
      # Start the preview
      # :MarkdownPreview
      # " Stop the preview"
      # :MarkdownPreviewStop
      # https://github.com/iamcco/markdown-preview.nvim/
      markdown-preview = {
        enable = true;
        settings = {
          theme = "dark";
          auto_start = 0;
          auto_close = 1;
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
      colorizer.enable = true;

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

      # vim-floaterm - Terminal manager for (neo)vim
      # https://github.com/voldikss/vim-floaterm
      floaterm = {
        enable = true;
        # Settings: https://nix-community.github.io/nixvim/plugins/floaterm/index.html
        settings = {
          autoinsert = true;
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

#      # multicursors.nvim - A multi cursor plugin for Neovim.
#      # https://github.com/smoka7/multicursors.nvim
#      multicursors = {
#        enable = true;
#        # Many settings: https://nix-community.github.io/nixvim/plugins/multicursors/index.html
#      };

      # nvim-spectre - Find the enemy and replace them with dark power.
      # https://github.com/nvim-pack/nvim-spectre/
      spectre = {
        enable = true;
        autoLoad = true;
        settings = {
          default = {
            find = {
              cmd = "rg";
              options = [
                "word"
                "hidden"
              ];
            };
            replace = {
              cmd = "sed";
            };
          };
          find_engine = {
            rg = {
              args = [
                "--color=never"
                "--no-heading"
                "--with-filename"
                "--line-number"
                "--column"
              ];
              cmd = "rg";
              options = {
                hidden = {
                  desc = "hidden file";
                  icon = "[H]";
                  value = "--hidden";
                };
                ignore-case = {
                  desc = "ignore case";
                  icon = "[I]";
                  value = "--ignore-case";
                };
                line = {
                  desc = "match in line";
                  icon = "[L]";
                  value = "-x";
                };
                word = {
                  desc = "match in word";
                  icon = "[W]";
                  value = "-w";
                };
              };
            };
          };
          is_insert_mode = false;
          live_update = true;
        };
      };

      # which-key.nvim - helps you remember your Neovim keymaps,
      # by showing available keybindings in a popup as you type.
      # https://github.com/folke/which-key.nvim
      which-key = {
        enable = true;
        # More settings here:
        # https://nix-community.github.io/nixvim/plugins/which-key/index.html
      };

      # Adds yazi floating window access into nvim.
      # https://github.com/mikavilpas/yazi.nvim/
      yazi = {
        enable = true;
        # Settings:
        # https://nix-community.github.io/nixvim/plugins/yazi/settings/index.html
        settings = {
          enable_mouse_support = true;
          floating_window_scaling_factor = 0.5;
          log_level = "debug";
          open_for_directories = false;
          yazi_floating_window_border = "single";
          yazi_floating_window_winblend = 50;
        };
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
          rust_analyzer = {
            # This has to be disabled if Rustaceanvim is enabled
            enable = false;
            installRustc = false;
            installCargo = false;
          };
          markdown_oxide = {
            enable = true;
            autostart = true;
          };
          taplo.enable = true;
          marksman.enable = true;
          lua_ls.enable = true;
          bashls.enable = true;
        };
      };
    };
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "todo.txt-vim";
      src = pkgs.fetchFromGitHub {
        owner = "freitass";
        repo = "todo.txt-vim";
        rev = "3bb5f9cf0d6c7ee91b476a97054c336104d2b6f5";
        hash = "sha256-s9ycwKgnDF5wWz3y3rHohDjq6mH066yDVr4xYReS6Ik=";
      };
    })];
  };
}
