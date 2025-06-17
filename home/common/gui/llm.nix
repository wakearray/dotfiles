{ lib, config, pkgs, ... }:
let
  llmClients = config.programs.llmClients;
in
{
  # /home/common/gui/llm.nix
  # A test module for testing LLM clients
  options.programs.llmClients = with lib; {
    enable = mkEnableOption "Enable a test ";
  };

  config = lib.mkIf llmClients.enable {
    home.packages = with pkgs; [
      ### Clients

      # AI client application and smart assistant
      # https://chatboxai.app/en
      # https://github.com/chatboxai/chatbox
      chatbox

      # Desktop client that supports for multiple LLM providers
      # https://github.com/CherryHQ/cherry-studio
      cherry-studio

      # ChatGPT based LLM Chat app
      # https://github.com/danny-avila/LibreChat
      librechat

      # An easy to use desktop app for experimenting with LLMs
      # https://lmstudio.ai/
      lmstudio

      # Comprehensive suite for LLMs with a user-friendly WebUI
      # https://github.com/open-webui/open-webui
      open-webui

      ### Tools

      # Concatenate a directory full of files into a single prompt for use with LLMs
      # https://github.com/simonw/files-to-prompt/
      files-to-prompt

      # A CLI tool that converts your codebase into a single LLM prompt
      # https://github.com/mufeedvh/code2prompt
      code2prompt

      ### Agents

      # Open-source, extensible AI agent that goes beyond code suggestions -
      # install, execute, edit, and test with any LLM
      # https://github.com/block/goose
      goose-cli
    ];
  };
}
