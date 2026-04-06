{ lib, ... }:
{
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](fg:color_01)"
          "[ ](fg:color_fg0 bg:color_01)"
          "$os"
          "$username"
          "[](fg:color_03 bg:color_01)"
          "$directory"
          "[](fg:color_02 bg:color_01)"
          "$git_branch"
          "$git_status"
          "[](fg:color_03 bg:color_01)"
          "$c"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:color_02 bg:color_01)"
          "$docker_context"
          "$conda"
          "[](fg:color_03 bg:color_01)"
          "$time"
          "[ ](fg:color_01)"
          "$line_break$character"
        ];
        palette = "lagurus";
        palettes.lagurus = {
          color_fg0 = "#352B24"; # Birch
          color_fg1 = "#352B24";
          color_fg2 = "#352B24";
          color_green = "#98971a";
          color_purple = "#b16286";
          color_red = "#cc241d";

          color_01 = "#B2A9A0"; # Cloudy
          color_02 = "#60443B"; # Kabul
          color_03 = "#675542"; # Tobacco Brown
        };
        os = {
          disabled = false;
          style = "bg:color_01 fg:color_fg0";
          symbols = {
            Windows = "󰍲 ";
            Android = " ";
            Arch = "󰣇 ";
            Debian = "󰣚 ";
            NixOS = " ";
          };
        };
        username = {
          show_always = true;
          style_user = "bg:color_01 fg:color_fg0";
          style_root = "bg:color_01 fg:color_fg0";
          format = "[ $user ]($style)";
        };
        directory = {
          style = "fg:color_fg0 bg:color_01";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";

          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
          };
        };
        git_branch = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol $branch ](fg:color_fg0 bg:color_01)]($style)";
        };
        git_status = {
          style = "bg:color_01";
          format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_01)]($style)";
        };
        nodejs = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        rust = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        php = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        kotlin = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        haskell = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        python = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_01)]($style)";
        };

        docker_context = {
          symbol = " ";
          style = "bg:color_01";
          format = "[[ $symbol( $context) ](fg:color_fg2 bg:color_01)]($style)";
        };

        conda = {
          style = "bg:color_01";
          format = "[[ $symbol( $environment) ](fg:color_fg2 bg:color_01)]($style)";
        };

        time = {
          disabled = false;
          use_12hr = true;
          time_format = "%l:%M %P";
          style = "bg:color_01";
          format = "[[  $time ](fg:color_fg1 bg:color_01)]($style)";
        };

        line_break = {
          disabled = false;
        };

        character = {
          disabled = false;
          success_symbol = "[](bold fg:color_green)";
          error_symbol = "[](bold fg:color_red)";
          vimcmd_symbol = "[](bold fg:color_green)";
          vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
          vimcmd_replace_symbol = "[](bold fg:color_purple)";
          vimcmd_visual_symbol = "[](bold fg:color_02)";
        };
      };
    };
  };
}

