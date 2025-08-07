{ pkgs, ... }:
{
  config = {
    home = {
      packages = with pkgs; [
        # Fancy TUI written in Go
        # https://github.com/charmbracelet/gum
        gum

        # Simple CLI database written in Go
        skate
      ];
      file.".local/bin/flakeworkflow" = {
        enable = true;
        force = true;
        executable = true;
        text = /*bash*/ ''
#!/usr/bin/env bash

FLAKE_ERROR_BIT=0
FLAKE_ERROR_LOG="/tmp/flakeworkflow.tmp"
IS_NIXOS=""
cat /etc/os-release | grep -q ID=nixos
if [ $? -eq 0 ]; then
  # This is NixOS
  IS_NIXOS=1
else
  #This isn't
  IS_NIXOS=0
fi

export BORDER="rounded"

git_status_format() {
  FLAKE_GIT_STATUS="$(git -C "$NH_FLAKE" status)"
  FLAKE_STATUS_SED_1="$(echo "$FLAKE_GIT_STATUS" | sed 's/On branch \(.*\)/On branch {{ Color "10" "\1" }}/')"
  FLAKE_STATUS_SED_2="$(echo "$FLAKE_STATUS_SED_1" | sed 's/modified: \(.*\)/{{ Color "10" "modified: \1"}}/')"
  FLAKE_STATUS_SED_3="$(echo "$FLAKE_STATUS_SED_2" | sed 's/new file: \(.*\)/{{ Color "10" "new file: \1"}}/')"

  FLAKE_GIT_STATUS="$(gum style "$(echo "$FLAKE_STATUS_SED_3" | gum format -t template)" --border-foreground="4" --padding="1 2" --margin="1 2")"
  gum join --align="center" "$FLAKE_GIT_STATUS"
}

rebuild() {
  if [ $IS_NIXOS -eq 1 ]; then
    zellij action rename-tab "Test Building NixOS:$FLAKE_GIT_BRANCH"
    gum log "Running test build with --show-trace option" -t rfc822 -l debug -s
    nh os test "$NH_FLAKE" -- --show-trace
    if [ $? -eq 0 ]; then
      gum log "Test build successful." -t rfc822 -l debug -s
      gum confirm "Do you want to add derivation to bootloader?"
      if [ $? -eq 0 ]; then
        zellij action rename-tab "Building NixOS:$FLAKE_GIT_BRANCH"
        gum log "Building NixOS flake." -t rfc822 -l debug -s
        nh os switch "$NH_FLAKE" && clear
      fi
    fi
  else
    gum log "Building Home Manager derivation." -t rfc822 -l debug -s
    zellij action rename-tab "Rebuilding Home Manager:$FLAKE_GIT_BRANCH"
    nh home switch -v -c "$(hostname)" && clear
  fi
}

commit() {
  zellij action rename-tab "Commit Flake:$FLAKE_GIT_BRANCH"
  clear
  git -C "$NH_FLAKE" add .
  git_status_format
  git -C "$NH_FLAKE" commit -m "$(gum input)" -m "$(gum write)"
  gum confirm "Do you want to push commit to origin/$FLAKE_GIT_BRANCH?"
  if [ $? -eq 0 ]; then
    git -C "$NH_FLAKE" push origin "$FLAKE_GIT_BRANCH" > "$FLAKE_ERROR_LOG" 2>&1
    handle_error
  fi
}

handle_error() {
  if [ $? -eq 0 ]; then
    FLAKE_ERROR_BIT=0
    echo "" > $FLAKE_ERROR_LOG
    clear
  else
    FLAKE_ERROR_BIT=1
  fi
}

error_message() {
  if [ $FLAKE_ERROR_BIT -eq 1 ]; then
    # - format error

    # - read error
    gum style "$(cat "$FLAKE_ERROR_LOG")"
    # - clear error message
    echo "" > $FLAKE_ERROR_LOG
    # - clear error_bit
    FLAKE_ERROR_BIT=0
  fi
}

clear

while true; do
  git -C "$NH_FLAKE" add .
  FLAKE_GIT_BRANCH="$(git -C "$NH_FLAKE" rev-parse --abbrev-ref HEAD)"
  zellij action rename-tab "Flake Workflow:$FLAKE_GIT_BRANCH"
  error_message
  git_status_format
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

  MENU_OPTIONS=("$FLAKE_OPTION_EDIT")

  if [ "$(git -C "$NH_FLAKE" stash list | wc -l)" -gt 0 ]; then
    MENU_OPTIONS+=("$FLAKE_OPTION_POP")
  fi

  if [ -n "$(git -C "$NH_FLAKE" status --porcelain)" ]; then
    # There's uncommitted changed staged
    MENU_OPTIONS+=("$FLAKE_OPTION_BUILD" "$FLAKE_OPTION_COMMIT" "$FLAKE_OPTION_STASH" "$FLAKE_OPTION_PULL")
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

  ans=$(gum choose "''${MENU_OPTIONS[@]}" --label-delimiter=":")

  case $ans in
    1)
      git -C "$NH_FLAKE" add .
      rebuild
      ;;
    2)
      commit
      ;;
    3)
      git -C "$NH_FLAKE" push origin "$FLAKE_GIT_BRANCH" > "$FLAKE_ERROR_LOG" 2>&1
      handle_error
      ;;
    4)
      zellij action rename-tab "Updating Flake:$FLAKE_GIT_BRANCH"
      gum log "Adding files to git" -t rfc822 -l info -s
      git -C "$NH_FLAKE" add .
      gum log "Updating flake" -t rfc822 -l info -s
      nix flake update --flake "$NH_FLAKE"
      gum log "Adding updated flake to git" -t rfc822 -l info -s
      git -C "$NH_FLAKE" add .
      gum log "Writing commit" -t rfc822 -l info -s
      git -C "$NH_FLAKE" commit -m "Updated flake"
      gum log "Pushing to origin repo" -t rfc822 -l info -s
      git -C "$NH_FLAKE" push origin "$FLAKE_GIT_BRANCH"
      rebuild
      ;;
    5)
      zellij action rename-tab "Edit Flake:$FLAKE_GIT_BRANCH"
      nvim --listen /tmp/nvim-editflake "$NH_FLAKE"
      clear
      ;;
    6)
      git -C "$NH_FLAKE" pull origin "$FLAKE_GIT_BRANCH" > "$FLAKE_ERROR_LOG" 2>&1
      handle_error
      ;;
    7)
      git -C "$NH_FLAKE" stash > "$FLAKE_ERROR_LOG" 2>&1
      handle_error
      ;;
    8)
      git -C "$NH_FLAKE" stash pop > "$FLAKE_ERROR_LOG" 2>&1
      handle_error
      ;;
    9)
      gum confirm "Create new branch?"
      if [ $? -eq 0 ]; then
        git -C "$NH_FLAKE" checkout -b "$(gum input)" > "$FLAKE_ERROR_LOG" 2>&1
        handle_error
      else
        SELECTED_BRANCH=$(git branch --format='%(refname:short)' | gum choose)
        if [ -n "$SELECTED_BRANCH" ]; then
          git -C "$NH_FLAKE" checkout "$SELECTED_BRANCH" > "$FLAKE_ERROR_LOG" 2>&1
          handle_error
        else
          clear
        fi
      fi
      ;;
    *)
      rm "$FLAKE_ERROR_LOG"
      clear
      zellij action rename-tab "Tab #1"
      break
      ;;
  esac
done

        '';
      };
    };
  };
}
