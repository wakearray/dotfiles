{ config, system-details, ... }:
let
  flakeworkflow = (if builtins.match "android" system-details.host-type != null
    then # Do this when on Android
      ''
git -c "$FLAKE" add .
git -c "$FLAKE" status
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
      git -c "$FLAKE" commit
      ;;
    4)
      git -c "$FLAKE" push origin ''$(git rev-parse --abbrev-ref HEAD)
      ;;
    5)
      nix flake update
      ;;
    6)
      nvim --listen /tmp/nvim ${config.home.homeDirectory}/dotfiles
      ;;
    *)
      break
      ;;
  esac
done
      ''
    else # Do this when not on Android (should only be NixOS)
      ''
CWD=''$(pwd)
cd ''$HOME/dotfiles
git -c "$FLAKE" add .
git -c "$FLAKE" status
while true; do
  echo "What would you like to do?"
  cat <<'END_CAT'
  1) Run a test build with --show-trace
  2) Rebuild system
  3) Make a commit
  4) Push current branch to remote
  5) Update flake and run a test build
  6) Continue editing flake

  Press any other key to leave this menu.
END_CAT

  echo ""

  read -k 1 ans
  case $ans in
    1)
      nh os test ${config.home.homeDirectory}/dotfiles -- --show-trace
      ;;
    2)
      nh os switch ${config.home.homeDirectory}/dotfiles
      ;;
    3)
      git -c "$FLAKE" commit
      ;;
    4)
      git -c "$FLAKE" push origin ''$(git rev-parse --abbrev-ref HEAD)
      ;;
    5)
      nix flake update
      git -c "$FLAKE" add .
      nh os test ${config.home.homeDirectory}/dotfiles -- --show-trace
      git -c "$FLAKE" status
      ;;
    6)
      nvim --listen /tmp/nvim ${config.home.homeDirectory}/dotfiles
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
      dotfiles = "$FLAKE";
      flake = "$FLAKE";
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
        zellij action rename-tab "Edit .zshrc"
        nvim --listen /tmp/nvim ''$FLAKE/home/common/zsh.nix
        if [[ `git -c "$FLAKE" status --porcelain` ]]; then
          flakeworkflow
        fi
      }

      editflake(){
        zellij action rename-tab "Edit Flake"
        nvim --listen /tmp/nvim ''$FLAKE
        if [[ `git -c "$FLAKE" status --porcelain` ]]; then
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

      notes(){
        zellij action rename-tab Notes
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

      function llm {
        zellij action rename-tab 'GPT-4o'
        tenere
      }

      eval `ssh-agent` && ssh-add && ssh-add ~/.ssh/signing_key
      clear
    '';
    sessionVariables = {
      EDITOR = "nvim --listen /tmp/nvim";
    };
    shellAliases = {
      l = "eza -la --tree --color=always --color-scale=all --color-scale-mode=fixed --icons=always --group-directories-first --git-ignore --level=1";
      c = "clear";

      # use zoxide instead of cd.
      cd = "z";
      cdi = "zi";

      # Launch neovim with a named server
      nvim = "nvim --listen /tmp/nvim";

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
