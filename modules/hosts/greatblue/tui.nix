{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Typing tester TUI
    # https://github.com/jrnxf/thokr
    thokr

    # Use Firefox's Readability API to extract useful
    # text from webpages and display them in the terminal
    # https://gitlab.com/gardenappl/readability-cli
    readability-cli

    # FastSSH is a TUI that allows you to quickly connect to your services by navigating through your SSH config.
    # https://github.com/julien-r44/fast-ssh
    fast-ssh

    # wiki-tui - A simple and easy to use Wikipedia Text User Interface
    # https://github.com/builditluc/wiki-tui
    wiki-tui

    # Tools for testing Vulkan driver compatibility
    vulkan-tools
  ];
}
