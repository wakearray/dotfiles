{ config, ... }:
{
  # zsh
  # More options found here:
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enable
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
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
      # path = "$HOME/.zsh_history";
      path = "${config.programs.zsh.dotDir}/.zsh_history";
      save = 20000;
      size = 20000;
    };
    historySubstringSearch = {
      enable = true;
    };
    # Things to put in the .zshrc file
    initContent = /*sh*/ ''
      clean(){
        clear
        setsid gum spin --timeout=305s --spinner dot --title "Cleaning the Nix store..." -- sleep 300 &

        GARBAGE="$(sudo nix-collect-garbage -d 2>&1 | tail -n 2)" && pkill -n gum
        GARBAGE_SED_1='s/note: currently hard linking saves \(.*\)/Hard linking saves: {{ Color "3" "\1" }}/'
        GARBAGE_SED_2='s/^\([0-9]\+\) store paths deleted, \([0-9.]\+\) \(.*\) freed/{{ Color "10" "\1" }} store paths deleted, {{ Color "10" "\2 \3" }} freed/'
        GENERATIONS="$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system)"
        GENERATIONS_SED_1='s/^\s\+\([0-9]\+\)\s\+\(20[2-9][0-9]-[0-1][0-9]-[0-3][0-9]\)\s\+\([0-2][0-9]:[0-5][0-9]:[0-5][0-9]\).*/Current NixOS generation: {{ Bold "\1"}} | Date: {{ Bold "\2" }} | Time: {{ Bold "\3" }}/'

        FORMATTED_GARBAGE="$(echo "$GARBAGE" | sed "$GARBAGE_SED_1" | sed "$GARBAGE_SED_2")"
        FORMATTED_GENERATIONS="$(echo "$GENERATIONS" | sed "$GENERATIONS_SED_1")"

        FORMATTED_GARBAGE_AND_GENERATIONS="$FORMATTED_GARBAGE

$FORMATTED_GENERATIONS"
        GENERATIONS_STATUS="$(gum style "$(echo "$FORMATTED_GARBAGE_AND_GENERATIONS" | gum format -t template)" --border="rounded" --border-foreground="4" --padding="1 2")"

        read -r FIRST_LINE <<< "$GENERATIONS_STATUS"
        # Get the length of that first line
        STRING_LEGNTH="''${#FIRST_LINE}"
        # Subtract the length from the terminal's total width
        REMAINING_COLUMNS=$((COLUMNS - STRING_LEGNTH));
        HALF=$((REMAINING_COLUMNS / 2))

        clear

        gum style "$GENERATIONS_STATUS" --margin="1 $HALF" --border="none"
      }

      ### Development Flakes

      bevyflake(){
        nix flake new --template github:wakearray/nix-templates/feature/automation-improvements#rust-bevy $1
        direnv allow $1
        cd $1
        cat << EOF > .gitignore
target/**
result-*/**
result*
result-bin
.direnv/**
.vscode/**
.cargo
EOF
        git init
        sed -i "s/bevy_template/$1/g" Cargo.toml
        git add .
        nix flake update
        git add .
        git commit -m "Initial commit"
      }

      # rustflake(){
      #   nix
      # }

      goflake() {
        nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#go" $1
        direnv allow $1
        cd $1
        cat << EOF > .gitignore
target/**
result-*/**
result*
result-bin
.direnv/**
.vscode/**
vendor/**
EOF
        git init
        git add .
        nix flake update
        git add .
        git commit -m "Initial commit"
      }

      ## Misc Shell Functions
      function mkcd {
        if [ ! -n "$1" ]; then
          echo "Enter a directory name"
        elif [ -d "$1" ]; then
          echo "$1 already exists, entering.."; cd $1
        else
          mkdir $1 && cd $1
        fi
      }

      eval $(ssh-agent -s)
      find ~/.ssh -type f -name 'id_ed25519*' ! -name '*.pub' -exec ssh-add {} \;
      rm /tmp/nvim-*
      clear
    '';
    shellAliases = {
      # Kills anything preventing the session from ending
      kcp = "kill $(ps -s $$ -o pid=)";
    };
  };
}
