{ lib, config, pkgs, ... }:

{
  imports = [
    ./starship.nix
  ];

  home = {
    username = "jess";
    homeDirectory = "/home/jess";
    stateVersion = "24.05";
    packages = with pkgs; [
      # aseprite - Animated sprite editor & pixel art tool
      # https://www.aseprite.org/
      aseprite 
    ];
  };

  # Theme:
  # Catppuccin Macchiato
  # https://catppuccin.com/palette#flavor-macchiato
  #
  # #181926  #a5adcb  #eed49f
  # #1e2030  #b8c0e0  #f5a97f
  # #24273a  #cad3f5  #ee99a0
  # #363a4f  #b7bdf8  #ed8796
  # #494d64  #8aadf4  #c6a0f6
  # #5b6078  #7dc4e4  #f5bde6
  # #6e738d  #91d7e3  #f0c6c6
  # #8087a2  #8bd5ca  #f4dbd6
  # #939ab7  #a6da95  
  # 
  catppuccin = {
    # Enable the Catppuccin Macchiato theme globally
    enable = true;
    flavor = "macchiato";
    pointerCursor = { 
      enable = true;
    };
  };

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

  programs = {
    home-manager.enable = true;

    # alacritty - A cross-platform, OpenGL terminal emulator
    # https://github.com/alacritty/alacritty
    alacritty = { 
      enable = true;
      settings = {
        selection = {
          save_to_clipboard = true;
	};
        cursor = {
          style = 
	  { 
	    shape = "Underline";
	    blinking = "Off";
	  };
	};
        terminal = {
          osc52 = "CopyPaste";
	};
        mouse = {
          bindings = [{ 
	    mouse = "Middle"; 
	    action = "Paste";
	  }];
	};
      };
    };

    # bat - a cat clone with wings
    # https://github.com/sharkdp/bat
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
    bat.enable = true;
    
    # btop - Resource monitor that shows usage and stats
    # https://github.com/aristocratos/btop
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.btop.enable
    btop.enable = true;   
    
    # fzf - The most supported command line fuzzy finder
    # https://github.com/junegunn/fzf
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # git
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
    git = {
      enable = true;
      # delta - A syntax-highlighting pager for git, diff, grep, and blame output
      # https://github.com/dandavison/delta
      delta.enable = true; 
    };
    
    # imv - a command line image viewer intended for use with tiling window managers
    # https://sr.ht/~exec64/imv/
    imv.enable = true;

    # mpv - Command line video player
    # https://github.com/mpv-player/mpv
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mpv.enable
    mpv.enable = true;

    # rofi - A window switcher, application launcher and dmenu replacement
    # https://github.com/davatorium/rofi
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rofi.enable
    rofi = {
      enable = true;
      # terminal = "${pkgs.alacritty}/bin/alacritty"
    };

    # skim - `sk` - Fuzzy Finder in rust!
    # https://github.com/lotabout/skim
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.skim.enable
    skim = {
      enable = true;
      enableZshIntegration = true;
    };

    # zellij - A terminal workspace with batteries included
    # https://github.com/zellij-org/zellij
    zellij = {
      enable = true;
      # `zellij.settings` expects yaml, but zellij has used kdl for years now.
      # Use `home.file` to write the approriate configuration files manually.
    };

    # zsh - 
    # 
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enable
    zsh = { 
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting = { enable = true; };
      autosuggestion = { 
        enable = true;
        strategy = [ "history" ];
      };
      history = { 
        append = true;
	ignoreAllDups = true;
	save = 20000;
	size = 20000;
      };
      historySubstringSearch = { 
        enable = true;
      };
      # Things to put in the .zshrc file
      initExtra = "\n";
      shellAliases = {
        l = "eza -la --tree --color=always --color-scale=all --color-scale-mode=fixed --icons=always --group-directories-first --git-ignore --level=1";
        c = "clear";
        # use zoxide instead of cd.
        cd = "z";
        cdi = "zi";
      };
    };
  };

  services = {
    # dunst - Lightweight and customizable notification daemon
    # https://github.com/dunst-project/dunst
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
    dunst.enable = true;
  };

  gtk = { 
    enable = true;
    catppuccin = {
      enable = true;
      gnomeShellTheme = true;
      icon = { enable = true; };
    };
  };
  qt = {
    enable = true;
    style = {
      catppuccin = {
        apply = true;
	enable = true;
      };
      name = "kvantum";
    };
    platformTheme.name = "kvantum";
  };
 
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = false;
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-enable-primary-paste = false;
      monospace-font-name = "Source Code Pro Light 10";
      show-battery-percentage = false;
    };
    "org/gnome/nautilus/icon-view" = {
      captions = [ "size" "date_modified" "none"];
      default-zoom-level = "small";
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      show-delete-permanently = true;
    };
    "org/gnome/desktop/session" = { 
      idle-delay= lib.gvariant.mkUint32 0;
    };
  };
}
