{ config, system-details, ... }:
let
  editflake = (if builtins.match "android" system-details.host-type != null
    then # Do this when on Android
      ''
CWD=''$(pwd)
cd ''$HOME/dotfiles
if [[ `git status --porcelain` ]]; then
  echo "Flake has been modified."
  git add .
  git status
  while true; do
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
    case $ans in
      2)
        nh home switch -v -c ${system-details.host-name}
        ;;
      3)
        git commit
        ;;
      4)
        git push origin ''$(git rev-parse --abbrev-ref HEAD)
        ;;
      5)
        nix flake update
        ;;
      6)
        nvim ${config.home.homeDirectory}/dotfiles
        ;;
      *)
        break
        ;;
    esac
  done
fi
      ''
    else # Do this when not on Android (should only be NixOS)
      ''
CWD=''$(pwd)
cd ''$HOME/dotfiles
if [[ `git status --porcelain` ]]; then
  echo "Flake has been modified."
  git add .
  git status
  while true; do
    echo "What would you like to do?"
    cat <<'END_CAT'
  1) Run a test build
  2) Rebuild system
  3) Make a commit
  4) Push current branch to remote
  5) Update flake
  6) Continue editing flake

  Press any other key to leave this menu.
END_CAT

    echo ""

    read -k 1 ans
    case $ans in
      1)
        nh os test ${config.home.homeDirectory}/dotfiles
        ;;
      2)
        nh os switch ${config.home.homeDirectory}/dotfiles
        ;;
      3)
        git commit
        ;;
      4)
        git push origin ''$(git rev-parse --abbrev-ref HEAD)
        ;;
      5)
        nix flake update
        ;;
      6)
        nvim ${config.home.homeDirectory}/dotfiles
        ;;
      *)
        break
        ;;
    esac
  done
fi
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
      dots = "$HOME/dotfiles";
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
    initExtra = ''
      # Functions

      ## Flake Functions

      editzsh(){
        nvim ''$HOME/dotfiles/home/common/zsh.nix
        flakeworkflow
      }

      editflake(){
        nvim ''$HOME/dotfiles
        flakeworkflow
      }

      flakeworkflow(){
        ${editflake}
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

      eval `ssh-agent` && ssh-add && ssh-add ~/.ssh/signing_key
      clear
    '';
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases = {
      l = "eza -la --tree --color=always --color-scale=all --color-scale-mode=fixed --icons=always --group-directories-first --git-ignore --level=1";
      c = "clear";
      # use zoxide instead of cd.
      cd = "z";
      cdi = "zi";
      # SSH Hosts
      lhosts = ''
	echo " \n \
	The available hosts for ssh are:      \n \
	                                      \n \
	greatblue        GPD Win 2 2023       \n \
	delaware         Dell Optiplex Server \n \
	lagurus          Cat Projector        \n \
	jerboa           Livingroom TV        \n \
	sebrightbantam   QNAP TS-251          \n \
	orloff           Odroid HC4           \n \
	cichlid          Jess' Desktop"
	'';
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

      ## Home Manager only
      starti3 = "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session i3";
    };
  };
}
