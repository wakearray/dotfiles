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

  environment.systemPackages = with pkgs; [
    zsh-nix-shell
  ];

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
      # SSH Hosts
      greatblue = "ssh 192.168.0.11"; # GPD Win 2 2023
      delaware = "ssh 192.168.0.46"; # NextCloud Server
      lagurus = "ssh 192.168.0.65"; # Cat's Projector
      jerboa = "ssh 192.168.0.32"; # Living Room TV
      cichlid = "echo 'This computer isn't setup yet'"; # Jess' Desktop
      sebrightbantam = "ssh 192.168.0.80";  # QNAP TS-251
      orloff = "echo 'This computer isn't setup yet'"; # Odroid HC4

      # Phones
      p80 = "ssh u0_a183@192.168.0.10 -p8022";
      mountp80 = "sshfs u0_a183@192.168.0.10:/data/data/com.termux/files /mnt/phones/p80 -p8022";

      kcp = "killCurrentSessionSpawn";

    };
    shellInit = ''
      SAVEHIST=10000

      zstyle ':completion:*' menu select # select completions with arrow keys
      zstyle ':completion:*\' group-name ''' # group results by category
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

      # Functions

      ## Flake Functions

      editzsh(){
        hash=''$(sha256sum "''$HOME/dotfiles/modules/zsh.nix")
        nvim ''$HOME/dotfiles/modules/zsh.nix
        newhash=''$(sha256sum "''$HOME/dotfiles/modules/zsh.nix")

        if [[ "''$hash" == "''$newhash" ]]; then
          echo "zsh.nix has not changed."
        else
          echo "Flake has been updated."
          rebuildflake
        fi
      }

      editflake(){
        CWD=''$(pwd)
        cd ''$HOME/dotfiles
        nvim
        git add .
        commitflake
        rebuildflake
        cd ''$CWD
      }

      commitflake(){
        echo "Would you like to commit the flake now?"
        read -q ans
        if [[ "''$ans" == "y" ]]; then
          echo "Commiting flake..."
          CWD=''$(pwd)
          cd ''$HOME/dotfiles
          git add .
          git commit
          echo -e "Would you like to also push to remote?"
          read -q ans
          if [[ "''$ans" == "y" ]]; then
            selected_branch = ''$(git rev-parse --abbrev-ref HEAD)
            echo "Pushing to remote..."
            git push origin ''$selected_branch
          else
            echo "Not pushing to remote."
          fi
          cd ''$CWD
        else
          echo "Not commiting flake at this time."
        fi
      }

      rebuildflake(){
        echo "Would you like to rebuild the system now?"
        read -q ans
        if [[ "''$ans" == "y" ]]; then
          CWD=''$(pwd)
          cd ''$HOME/dotfiles
          git add .
          sudo nixos-rebuild switch --flake .
          cd ''$CWD
          echo "Please close and reopen the terminal to use the new shellInit."
        else
          echo "Flake has been edited. Run 'rebuildflake' to rebuild the current system."
        fi
      }

      flakepush(){
        CWD=''$(pwd)
        cd ''$HOME/dotfiles
        git add .
        git commit
        git push origin main
        echo "Flake has been pushed to GitHub."
        rebuildflake
        cd ''$CWD
      }

      ### Development Flakes

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

      ## Misc Shell Functions

      notes(){
        nvim ~/notes
      }

      killCurrentSessionSpawn(){
        kill ''$(ps -s ''$''$ -o pid=)
      }

      function mkcd {
        if [ ! -n "''$1" ]; then
          echo "Enter a directory name"
        elif [ -d ''$1 ]; then
          echo "\`''$1' already exists, entering.."; cd ''$1
        else
          mkdir ''$1 && cd ''$1
        fi
      }

      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      eval "''$(zoxide init zsh)"
      eval "''$(starship init zsh)"
      #eval "''$(atuin init zsh)"
    '';
  };
}
