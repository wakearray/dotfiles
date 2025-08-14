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
FLAKE_LOG_UUID="$(uuidgen | sed 's/-.*//')"
FLAKE_ERROR_LOG="/tmp/flakeworkflow_error_log_$FLAKE_LOG_UUID.tmp"
FLAKE_COMMIT_LOG="/tmp/flakeworkflow_commit_log_$FLAKE_LOG_UUID.tmp"
FLAKE_PULL_LOG="/tmp/flakeworkflow_pull_log_$FLAKE_LOG_UUID.tmp"
FLAKE_PUSH_LOG="/tmp/flakeworkflow_push_log_$FLAKE_LOG_UUID.tmp"
IS_NIXOS=0

export BORDER="rounded"

init() {
  if grep -q ID=nixos < /etc/os-release; then
    # This is NixOS
    IS_NIXOS=1
  else
    #This isn't
    IS_NIXOS=0
  fi

  echo "" > "$FLAKE_ERROR_LOG"
  echo "" > "$FLAKE_COMMIT_LOG"
  echo "" > "$FLAKE_PUSH_LOG"
  echo "" > "$FLAKE_PULL_LOG"

  clear
}

close() {
  rm "$FLAKE_ERROR_LOG"
  rm "$FLAKE_COMMIT_LOG"
  rm "$FLAKE_PUSH_LOG"
  rm "$FLAKE_PULL_LOG"
  clear
  zellij action undo-rename-tab
}

center() {
  # String to center is $1
  # The first line when surrounded by a gum style border will be the longest
  read -r FIRST_LINE <<< "$1"
  # Get the length of that first line
  STRING_LEGNTH="''${#FIRST_LINE}"
  # Subtract the length from the terminal's total width
  REMAINING_COLUMNS=$((COLUMNS - STRING_LEGNTH));
  HALF=$((REMAINING_COLUMNS / 2))
  gum style "$1" --margin="1 $HALF" --border="none"
}

git_status_format() {
  FLAKE_GIT_STATUS="$(git -C "$NH_FLAKE" status)"
  FLAKE_STATUS_SED_1='s/On branch \(.*\)/On branch {{ Color "10" "\1" }}/'
  FLAKE_STATUS_SED_2='s/modified: \(.*\)/{{ Color "10" "modified: \1"}}/'
  FLAKE_STATUS_SED_3='s/new file: \(.*\)/{{ Color "10" "new file: \1"}}/'
  FLAKE_STATUS_FORMATTED="$(git -C "$NH_FLAKE" status |\
    sed "$FLAKE_STATUS_SED_1" |\
    sed "$FLAKE_STATUS_SED_2" |\
    sed "$FLAKE_STATUS_SED_3")"

  FLAKE_GIT_STATUS="$(gum style "$(echo "$FLAKE_STATUS_FORMATTED" | gum format -t template)" --border-foreground="4" --padding="1 2")"
  center "$FLAKE_GIT_STATUS"
}

rebuild() {
  git -C "$NH_FLAKE" add .
  if [ $IS_NIXOS -eq 1 ]; then
    zellij action rename-tab "Test Building NixOS:$FLAKE_GIT_BRANCH"
    gum log "Running test build with --show-trace option" -t rfc822 -l debug -s
    if nh os test "$NH_FLAKE" -- --show-trace; then
      gum log "Test build successful." -t rfc822 -l debug -s
      if gum confirm "Do you want to add derivation to bootloader?"; then
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
  git -C "$NH_FLAKE" commit -m "$(gum input)" -m "$(gum write)" > "$FLAKE_COMMIT_LOG" 2>&1
  commit_message
  if gum confirm "Do you want to push commit to origin/$FLAKE_GIT_BRANCH?"; then
    push
  fi
  clear
}

push() {
  if git -C "$NH_FLAKE" push origin "$FLAKE_GIT_BRANCH" > "$FLAKE_PUSH_LOG" 2>&1; then
    FLAKE_ERROR_BIT=0
  else
    cat "$FLAKE_PUSH_LOG" > "$FLAKE_ERROR_LOG"
    echo "" > "$FLAKE_PUSH_LOG"
    FLAKE_ERROR_BIT=1
  fi
  clear
}

pull() {
  if git -C "$NH_FLAKE" pull origin "$FLAKE_GIT_BRANCH" > "$FLAKE_PULL_LOG" 2>&1; then
    FLAKE_ERROR_BIT=0
    pull_message
    if gum confirm "Build system?"; then
      rebuild
    fi
  else
    cat "$FLAKE_PULL_LOG" > "$FLAKE_ERROR_LOG"
    echo "" > "$FLAKE_PULL_LOG"
    FLAKE_ERROR_BIT=1
  fi
  clear
}

update() {
  zellij action rename-tab "Updating Flake:$FLAKE_GIT_BRANCH"
  gum log "Adding files to git" -t rfc822 -l debug -s
  git -C "$NH_FLAKE" add .
  gum log "Updating flake" -t rfc822 -l debug -s
  nix flake update --flake "$NH_FLAKE"
  gum log "Adding updated flake to git" -t rfc822 -l debug -s
  git -C "$NH_FLAKE" add .
  gum log "Writing commit" -t rfc822 -l debug -s
  git -C "$NH_FLAKE" commit -m "Updated flake"
  gum log "Pushing to origin repo" -t rfc822 -l debug -s
  git -C "$NH_FLAKE" push origin "$FLAKE_GIT_BRANCH"
  rebuild
}

branch() {
  if gum confirm "Create new branch?"; then
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
}

handle_error() {
  if [ $? -eq 0 ]; then
    FLAKE_ERROR_BIT=0
    echo "" > "$FLAKE_ERROR_LOG"
  else
    FLAKE_ERROR_BIT=1
  fi
  clear
}

error_message() {
  if [ $FLAKE_ERROR_BIT -eq 1 ]; then
    FLAKE_ERROR_TEXT="$(cat "$FLAKE_ERROR_LOG")"

    # TODO: Add sed arguments to filter text and
    # format it in `gum format` template style.

    FLAKE_ERROR_TEXT_STYLED="$(gum style \
      "$(echo "$FLAKE_ERROR_TEXT" | \
      gum format -t template)" \
      --border-foreground="1" \
      --padding="1 2")"

    center "$FLAKE_ERROR_TEXT_STYLED"
    # Clear error message
    echo "" > "$FLAKE_ERROR_LOG"
    # Clear error_bit
    FLAKE_ERROR_BIT=0
  fi
}

commit_message() {
  if [ ! -s "$FLAKE_COMMIT_LOG" ]; then
    # $FLAKE_COMMIT_LOG has something in it
    FLAKE_COMMIT_TEXT="$(cat "$FLAKE_COMMIT_LOG")"

    # TODO: Add sed arguments to filter text and
    # format it in `gum format` template style.

    FLAKE_COMMIT_TEXT_STYLED="$(gum style \
      "$(echo "$FLAKE_COMMIT_TEXT" | \
      gum format -t template)" \
      --border-foreground="2" \
      --padding="1 2")"

    center "$FLAKE_COMMIT_TEXT_STYLED"

    # Clear the log
    echo "" > "$FLAKE_COMMIT_LOG"
  fi
}

push_message() {
  if [ ! -s "$FLAKE_PUSH_LOG" ]; then
    # $FLAKE_PUSH_LOG has something in it
    # Format (todo)

    # Sample text:
    # [main 945df99] Added new flakeworkflow script using gum
    # 4 files changed, 216 insertions(+), 123 deletions(-)
    # create mode 100644 home/common/shell/flakeworkflow.nix
    FLAKE_PUSH_TEXT="$(cat "$FLAKE_PUSH_LOG")"

    # TODO: Add sed arguments to filter text and
    # format it in `gum format` template style.

    FLAKE_PUSH_TEXT_STYLED="$(gum style \
      "$(echo "$FLAKE_PUSH_TEXT" | \
      gum format -t template)" \
      --border-foreground="2" \
      --padding="1 2")"

    center "$FLAKE_PUSH_TEXT_STYLED"
    # Clear the log
    echo "" > "$FLAKE_PUSH_LOG"
  fi
}

pull_message() {
  if [ ! -s "$FLAKE_PULL_LOG" ]; then
    # $FLAKE_PULL_LOG has something in it
    FLAKE_PULL_TEXT="$(cat "$FLAKE_PULL_LOG")"

    # TODO: Add sed arguments to filter text and
    # format it in `gum format` template style.

    FLAKE_PULL_TEXT_STYLED="$(gum style \
      "$(echo "$FLAKE_PULL_TEXT" | \
      gum format -t template)" \
      --border-foreground="2" \
      --padding="1 2")"

    center "$FLAKE_PULL_TEXT_STYLED"
    # Clear the log
    echo "" > "$FLAKE_PULL_LOG"
  fi
}

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
}
