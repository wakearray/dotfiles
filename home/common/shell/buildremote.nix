{ lib, config, pkgs, ... }:
let
  cfg = config.scripts.remoteBuildScript;
in
{
  options.scripts.remoteBuildScript = with lib; {
    enable = mkEnableOption "Enable the remote build script.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # Fancy TUI written in Go
        # https://github.com/charmbracelet/gum
        gum

        # Simple CLI database written in Go
        skate
      ];
      file.".local/bin/remotebuild" = {
        enable = true;
        force = true;
        executable = true;
        text = /*bash*/ ''
#!/usr/bin/env bash

build_choose_menu() {
  FLAKE_OPTION_BUILD="Build system:1"
  FLAKE_OPTION_COMMIT="Make a commit:2"
  FLAKE_OPTION_PUSH="Push to origin/$FLAKE_GIT_BRANCH:3"
  FLAKE_OPTION_UPDATE="Update flake and build:4"
  FLAKE_OPTION_EDIT="Edit flake:5"
  FLAKE_OPTION_PULL="Pull from origin/$FLAKE_GIT_BRANCH:6"
  FLAKE_OPTION_STASH="Stash staged changes:7"
  FLAKE_OPTION_POP="Restore stashed changes:8"
  FLAKE_OPTION_BRANCH="Change git branch:9"
  FLAKE_OPTION_QUIT="Quit:10"

  MENU_OPTIONS=("$FLAKE_OPTION_EDIT" "$FLAKE_OPTION_BUILD")

  if [ "$(git -C "$NH_FLAKE" stash list | wc -l)" -gt 0 ]; then
    MENU_OPTIONS+=("$FLAKE_OPTION_POP")
  fi

  if [ -n "$(git -C "$NH_FLAKE" status --porcelain)" ]; then
    # There's uncommitted changed staged
    MENU_OPTIONS+=("$FLAKE_OPTION_COMMIT" "$FLAKE_OPTION_STASH" "$FLAKE_OPTION_PULL")
  else
    if ! git -C "$NH_FLAKE" diff --quiet "origin/$FLAKE_GIT_BRANCH"; then
      # There's committed changes waiting to be pushed
      MENU_OPTIONS+=("$FLAKE_OPTION_PUSH")
    else
      # Repo is up to date with origin/$FLAKE_GIT_BRANCH
      MENU_OPTIONS+=("$FLAKE_OPTION_PULL")
    fi
  fi

  MENU_OPTIONS+=("$FLAKE_OPTION_UPDATE" "$FLAKE_OPTION_BRANCH" "$FLAKE_OPTION_QUIT")

  gum choose "''${MENU_OPTIONS[@]}" --label-delimiter=":"
}

init

while true; do
  git -C "$NH_FLAKE" add .
  FLAKE_GIT_BRANCH="$(git -C "$NH_FLAKE" rev-parse --abbrev-ref HEAD)"
  zellij action rename-tab "Flake Workflow:$FLAKE_GIT_BRANCH"
  push_message
  pull_message
  error_message
  git_status_format

  ans=$(build_choose_menu)

  case $ans in
    1)
      rebuild
      ;;
    2)
      commit
      ;;
    3)
      push
      ;;
    4)
      update
      ;;
    5) # Editflake
      zellij action rename-tab "Edit Flake:$FLAKE_GIT_BRANCH"
      nvim --listen /tmp/nvim-editflake "$NH_FLAKE"
      clear
      ;;
    6)
      pull
      ;;
    7) # Stash
      git -C "$NH_FLAKE" stash > "$FLAKE_ERROR_LOG" 2>&1
      handle_error
      ;;
    8) # Stash pop
      git -C "$NH_FLAKE" stash pop > "$FLAKE_ERROR_LOG" 2>&1
      handle_error
      ;;
    9)
      branch
      ;;
    *) # Exit
      close
      break
      ;;
  esac
done
        '';
      };
    };
  };
#build_remote() {
#  cd "$NH_FLAKE"
#  git add .
#  nh os switch --hostname "Delaware" --target-host kent@192.168.0.46 --build-host kent@192.168.0.46
#}

}
