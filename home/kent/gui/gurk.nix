{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # Signal Messenger client for terminal
      # https://github.com/boxdot/gurk-rs
      unstable.gurk-rs
    ];
#      file.".config/gurk.toml" = {
#        enable = true;
#        force = true;
#        text = ''
#  default_keybindings = true
#
#  [keybindings.anywhere]
#  ctrl-c = ""
#  ctrl-q = "quit"
#
#  [keybindings.normal]
#  ctrl-j = ""
#  ctrl-k = "kill_line"
#  ctrl-n = "select_channel next"
#  ctrl-p = "select_channel previous"
#  alt-c = "toggle_channel_modal"
#  up = "select_message previous entry"
#  down = "select_message next entry"
#
#  [keybindings.channel_modal]
#  ctrl-j = ""
#  ctrl-k = ""
#  ctrl-n = "select_channel_modal next"
#  ctrl-p = "select_channel_modal previous"
#
#  [keybindings.message_selected]
#  alt-y = ""
#  alt-w = "copy_message selected"
#        '';
#      };
  };

## Default keybindings
#
#  * App navigation
#    * `f1` Toggle help panel.
#    f1 = "help"
#    * `ctrl+c` Quit.
#    ctrl-c = "quit"
#  * Message input
#    * `tab` Send emoji from input line as reaction on selected message.
#    tab = "react"
#    * `alt+enter` Switch between multi-line and singl-line input modes.
#    * `alt+left`, `alt+right` Jump to previous/next word.
#    * `ctrl+w / ctrl+backspace / alt+backspace` Delete last word.
#    * `ctrl+u` Delete to the start of the line.
#    * `enter` *when input box empty in single-line mode* Open URL from selected message.
#    * `enter` *otherwise* Send message.
#  * Multi-line message input
#    * `enter` New line
#    * `ctrl+j / Up` Previous line
#    * `ctrl+k / Down` Next line
#  * Cursor
#    * `alt+f / alt+Right / ctrl+Right` Move forward one word.
#    * `alt+b / alt+Left / ctrl+Left` Move backward one word.
#    * `ctrl+a / Home` Move cursor to the beginning of the line.
#    * `ctrl+e / End` Move cursor the the end of the line.
#  * Message/channel selection
#    * `esc` Reset message selection or close channel selection popup.
#    * `alt+Up / alt+k / PgUp` Select previous message.
#    * `alt+Down / alt+j / PgDown` Select next message.
#    * `ctrl+j / Up` Select previous channel.
#    * `ctrl+k / Down` Select next channel.
#    * `ctrl+p` Open / close channel selection popup.
#  * Clipboard
#    * `alt+y` Copy selected message to clipboard.
#  * Help menu
#    * `esc` Close help panel.
#    * `ctrl+j / Up / PgUp` Previous line
#    * `ctrl+k / Down / PgDown` Next line

### Supported commands
#  help
#  quit
#  toggle_channel_modal
#  toggle_multiline
#  react
#  scroll help up|down entry
#  move_text previous|next character|word|line
#  select_channel previous|next
#  select_channel_modal previous|text
#  select_message previous|next entry
#  kill_line
#  kill_whole_line
#  kill_backward_line
#  kill_word
#  copy_message selected
#  beginning_of_line
#  end_of_line
#  delete_character previous
#  edit_message
#  open_url

}
