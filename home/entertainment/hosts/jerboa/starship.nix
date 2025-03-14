{ lib, ... }:
{
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](color_01)"
          "$os"
          "$username"
          "[](bg:color_02 fg:color_01)"
          "$directory"
          "[](fg:color_02 bg:color_03)"
          "$git_branch"
          "$git_status"
          "[](fg:color_03 bg:color_04)"
          "$c"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:color_04 bg:color_05)"
          "$docker_context"
          "$conda"
          "[](fg:color_05 bg:color_06)"
          "$time"
          "[ ](fg:color_06)"
          "$line_break$character"
        ];
        palette = "gruvbox_dark";
        palettes.gruvbox_dark = {
          color_fg0 = "#BFADA3";
          color_fg1 = "#B89685";
          color_fg2 = "#3F2A01";
          color_green = "#98971a";
          color_purple = "#b16286";
          color_red = "#cc241d";

          color_01 = "#504746";
          color_02 = "#B89685";
          color_03 = "#BFADA3";
          color_04 = "#A4DDF4";
          color_05 = "#72847B";
          color_06 = "#3F2A01";
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
          style = "fg:color_fg0 bg:color_02";
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
          style = "bg:color_03";
          format = "[[ $symbol $branch ](fg:color_fg0 bg:color_03)]($style)";
        };
        git_status = {
          style = "bg:color_03";
          format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_03)]($style)";
        };
        nodejs = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        rust = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        php = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        kotlin = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        haskell = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        python = {
          symbol = " ";
          style = "bg:color_04";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_04)]($style)";
        };

        docker_context = {
          symbol = " ";
          style = "bg:color_05";
          format = "[[ $symbol( $context) ](fg:color_fg2 bg:color_05)]($style)";
        };

        conda = {
          style = "bg:color_05";
          format = "[[ $symbol( $environment) ](fg:color_fg2 bg:color_05)]($style)";
        };

        time = {
          disabled = false;
          use_12hr = true;
          time_format = "%l:%M %P";
          style = "bg:color_06";
          format = "[[  $time ](fg:color_fg1 bg:color_06)]($style)";
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

