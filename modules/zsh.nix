{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Set zsh as the default user shell.
  users.defaultUserShell = pkgs.zsh;

  # Turn on zsh.
  programs.zsh = {
    enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    histFile = "$HOME/.zsh_history";
    histSize = 10000;
    setOptions = [
      "ALWAYS_TO_END"
      "AUTO_LIST"
      "AUTO_MENU"
      "APPEND_HISTORY"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_REDUCE_BLANKS"
      "INC_APPEND_HISTORY"
      "CORRECT_ALL"
    ];
    shellAliases = {
      # use lsd instead of ls.
      l = "lsd -al";
      # use zoxide instead of cd.
      cd = "z";
      cdi = "zi";
      delaware = "ssh 192.168.0.46";
      kcp = "killCurrentSessionSpawn";
    };
    shellInit = ''
      SAVEHIST=10000

      zstyle ':completion:*' menu select # select completions with arrow keys
      zstyle ':completion:*\' group-name ''' # group results by category
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

      # Functions

      editzsh(){
        nvim ~/.dotfiles/modules/zsh
        CWD=''${pwd}
        cd ~/.dotfiles
        git add .
        sudo nixos-rebuild switch --flake .
        cd $CWD
        echo "Please close and reopen the terminal to use the new shellInit."
      }

      flakepush(){
        CWD=''${pwd}
        cd ~/.dotfiles
        git add .
        git commit
        git push origin main
        echo "Flake has been pushed to GitHub."
        cd $CWD
      }

      killCurrentSessionSpawn(){
        kill ''$(ps -s ''$''$ -o pid=)
      }

      function mkcd {
        if [ ! -n "''$1" ]; then
          echo "Enter a directory name"
        elif [ -d ''$1 ]; then
          echo "\`''$1' already exists"; cd ''$1
        else
          mkdir ''$1 && cd ''$1
        fi
      }

      bevyflake(){
        nix flake new --template github:wakearray/nix-templates/feature/automation-improvements#rust-bevy ''$1
        direnv allow ''$1
        cd ''$1
        rm init.sh
        git init
        sed -i "s/bevy_template/''$1/g" Cargo.toml
        git add * .envrc .gitignore
        git reset -- init.sh
        nix flake update
        git add flake.lock Cargo.lock
        git commit -m "Initial commit"
      }

      eval "''$(zoxide init zsh)"
      eval "''$(starship init zsh)"
      #eval "''$(atuin init zsh)"
    '';
  };
}
