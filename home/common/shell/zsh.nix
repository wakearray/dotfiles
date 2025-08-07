{ config, systemDetails, ... }:
let
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
      clean(){
        clear
        sudo nix-collect-garbage -d 2>&1 | tail -n 2
        echo "Avaliable NixOS generations:"
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
      }

      ### Development Flakes

      bevyflake(){
        nix flake new --template github:wakearray/nix-templates/feature/automation-improvements#rust-bevy ''$1
        direnv allow ''$1
        cd ''$1
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
        sed -i "s/bevy_template/''$1/g" Cargo.toml
        git add .
        nix flake update
        git add .
        git commit -m "Initial commit"
      }

      rustflake(){
        nix
      }

      goflake() {
        nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#go" ''$1
        direnv allow ''$1
        cd ''$1
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
