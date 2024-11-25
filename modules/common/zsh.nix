{ pkgs, ... }:
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
      l = "eza -la --tree --color=always --color-scale=all --color-scale-mode=fixed --icons=always --group-directories-first --git-ignore --level=1";
      c = "clear";
      # use zoxide instead of cd.
      cd = "z";
      cdi = "zi";

      kcp = "killCurrentSessionSpawn";

    };
    shellInit = ''
      SAVEHIST=10000

      zstyle ':completion:*' menu select # select completions with arrow keys
      zstyle ':completion:*\' group-name ''' # group results by category
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

      # Functions

      clean(){
        nix-collect-garbage -d
	      nix-store --gc
	      clear
	      echo "Avaliable NixOS generations:"
	      nix-env --list-generations --profile /nix/var/nix/profiles/system
      }

      ## Misc Shell Functions

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
    '';
  };
}
