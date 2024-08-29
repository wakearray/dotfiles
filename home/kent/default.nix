{ lib, config, pkgs, ... }:

{
  home = {
    username = "kent";
    homeDirectory = "/home/kent";
    stateVersion = "24.05";
    packages = with pkgs; [
      # 
    ];
  };
  
  imports = [
    ../common
    ./starship.nix
    ./zellij.nix
  ];
  
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
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };

    # skim - `sk` - Fuzzy Finder in rust!
    # https://github.com/lotabout/skim
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.skim.enable
    skim = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services = {
    # dunst - Lightweight and customizable notification daemon
    # https://github.com/dunst-project/dunst
    # More options found here:
    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.dunst.enable
    dunst.enable = true;
  };
}
