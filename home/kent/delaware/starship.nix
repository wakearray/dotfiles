{ lib, ... }:
{
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](color_red)"
          "[](fg:color_yellow bg:color_red)"
          "$os"
          "$username"
          "[](fg:color_black bg:color_white)"
          "$directory"
          "[](fg:color_black bg:color_white)"
          "$git_branch"
          "$git_status"
          "[](fg:color_black bg:color_white)"
          "$c"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:color_black bg:color_white)"
          "$docker_context"
          "$conda"
          "[](fg:color_black bg:color_white)"
          "$time"
          "[ ](fg:color_white)"
          "$line_break$character"
        ];
        palette = "delaware";
        palettes.delaware = {
          color_black  = "#000000";
          color_green  = "#98971A";
          color_purple = "#B16286";
          color_red    = "#CC241D";
          color_yellow = "#FFD000";
          color_white  = "#FFFFFF";
        };
        os = {
          disabled = false;
          style = "bg:color_white fg:color_black";
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
          style_user = "bg:color_white fg:color_black";
          style_root = "bg:color_white fg:color_red";
          format = "[ $user ]($style)";
        };
        directory = {
          style = "fg:color_black bg:color_white";
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
          style = "bg:color_white";
          format = "[[ $symbol $branch ](fg:color_white bg:color_black)]($style)";
        };
        git_status = {
          style = "bg:color_white";
          format = "[[($all_status$ahead_behind )](fg:color_black bg:color_white)]($style)";
        };
        nodejs = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        c = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        rust = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        php = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        java = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        kotlin = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        haskell = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        python = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $version) ](fg:color_black bg:color_white)]($style)";
        };
        docker_context = {
          symbol = " ";
          style = "bg:color_white";
          format = "[[ $symbol( $context) ](fg:color_black bg:color_white)]($style)";
        };
        conda = {
          style = "bg:color_white";
          format = "[[ $symbol( $environment) ](fg:color_black bg:color_white)]($style)";
        };
        time = {
          disabled = false;
          use_12hr = true;
          time_format = "%l:%M %P";
          style = "bg:color_white";
          format = "[[  $time ](fg:color_white bg:color_black)]($style)";
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
          vimcmd_visual_symbol = "[](bold fg:color_yellow)";
        };
      };
    };
  };
}
