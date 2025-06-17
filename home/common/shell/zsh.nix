{ config, systemDetails, ... }:
let
  hostname = config.home.systemDetails.hostName;
  flakeworkflow = (if
      (builtins.match "android" systemDetails.hostType != null)
    then # Do this when on Android
      /*sh*/ ''
while true; do
  git -C "$NH_FLAKE" add .
  git -C "$NH_FLAKE" status
  echo "What would you like to do?"
  cat <<'END_CAT'
  2) Build home-manager derivation
  3) Make a commit
  4) Push current branch to remote
  5) Update flake
  6) Continue editing flake

  Press any other key to leave this menu.
END_CAT

  echo ""

  read -k 1 ans
  echo ""
  case $ans in
    2)
      git -C "$NH_FLAKE" add .
      nh home switch -v -c ${hostname}
      ;;
    3)
      git -C "$NH_FLAKE" add .
      git -C "$NH_FLAKE" commit
      ;;
    4)
      git -C "$NH_FLAKE" push origin ''$(git -C "$NH_FLAKE" rev-parse --abbrev-ref HEAD)
      ;;
    5)
      git -C "$NH_FLAKE" add .
      nix flake update --flake "$NH_FLAKE"
      git -C "$NH_FLAKE" add .
      ;;
    6)
      nvim --listen /tmp/nvim-editflake ${config.home.homeDirectory}/dotfiles
      ;;
    7)
      git -C "$NH_FLAKE" pull origin $(git -C "$NH_FLAKE" rev-parse --abbrev-ref HEAD)
      ;;
    *)
      break
      ;;
  esac
done
      ''
    else # Do this when not on Android (should only be NixOS)
      /*sh*/ ''
while true; do
  git -C "$NH_FLAKE" add .
  git -C "$NH_FLAKE" status
  echo "What would you like to do?"
  cat <<'END_CAT'
  1) Run a test build with --show-trace
  2) Rebuild system
  3) Make a commit
  4) Push current branch to remote
  5) Update flake and run a test build
  6) Continue editing flake
  7) Pull current branch from remote

  Press any other key to leave this menu.
END_CAT

  echo ""

  read -k 1 ans
  case $ans in
    1)
      git -C "$NH_FLAKE" add .
      nh os test ${config.home.homeDirectory}/dotfiles -- --show-trace
      ;;
    2)
      git -C "$NH_FLAKE" add .
      nh os switch ${config.home.homeDirectory}/dotfiles
      ;;
    3)
      git -C "$NH_FLAKE" add .
      git -C "$NH_FLAKE" commit
      ;;
    4)
      git -C "$NH_FLAKE" push origin $(git -C "$NH_FLAKE" rev-parse --abbrev-ref HEAD)
      ;;
    5)
      git -C "$NH_FLAKE" add .
      nix flake update
      git -C "$NH_FLAKE" add .
      nh os test ${config.home.homeDirectory}/dotfiles -- --show-trace
      git -C "$NH_FLAKE" status
      ;;
    6)
      nvim --listen /tmp/nvim-editflake ${config.home.homeDirectory}/dotfiles
      ;;
    7)
      git -C "$NH_FLAKE" pull origin $(git -C "$NH_FLAKE" rev-parse --abbrev-ref HEAD)
      ;;
    *)
      break
      ;;
  esac
done
      ''
  );
in
{
  # zsh
  # More options found here:
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enable
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };
    dirHashes = {
      dotfiles = "$NH_FLAKE";
      flake = "$NH_FLAKE";
    };
    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      path =  "$HOME/.zsh_history";
      save = 20000;
      size = 20000;
    };
    historySubstringSearch = {
      enable = true;
    };
    # Things to put in the .zshrc file
    initContent = /*sh*/ ''
      ## Flake Functions
      editflake(){
        zellij action rename-tab "Edit Flake"
        nvim --listen /tmp/nvim-editflake $NH_FLAKE
        if [[ `git -C "$NH_FLAKE" status --porcelain` ]]; then
          flakeworkflow
        fi
      }

      flakeworkflow(){
        ${flakeworkflow}
      }

      clean(){
        sudo nix-collect-garbage -d
        sudo nix-store --gc
        clear
        echo "Avaliable NixOS generations:"
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
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
      function mkcd {
        if [ ! -n "''$1" ]; then
          echo "Enter a directory name"
        elif [ -d ''$1 ]; then
          echo "\`''$1' already exists, entering.."; cd ''$1
        else
          mkdir ''$1 && cd ''$1
        fi
      }

      eval `ssh-agent` && ssh-add && ssh-add ~/.ssh/signing_key
      clear
    '';
    shellAliases = {
      # Kills anything preventing the session from ending
      kcp = "kill $(ps -s $$ -o pid=)";
    };
  };
}
