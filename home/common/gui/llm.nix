{ lib, config, pkgs, ... }:
let
  cfg = config.programs.llmClients;
in
{
  # /home/common/gui/llm.nix
  # A test module for testing LLM clients
  options.programs.llmClients = with lib; {
    enable = mkEnableOption "Enable Chatbox GUI for handling LLM/GPT interactions.";

    local = mkEnableOption "Enable LM Studio and OpenWebUI to run models locally on this machine.";

    tools = mkEnableOption "Enable files-to-prompt, code2prompt, and goose cli.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # AI client application and smart assistant
      # https://chatboxai.app/en
      # https://github.com/chatboxai/chatbox
      pkgs.chatbox
    ] ++ lib.optionals cfg.local [
      # An easy to use desktop app for experimenting with LLMs
      # https://lmstudio.ai/
      pkgs.lmstudio

      # Comprehensive suite for LLMs with a user-friendly WebUI
      # https://github.com/open-webui/open-webui
      pkgs.open-webui
    ] ++ lib.optionals cfg.tools [
      # Concatenate a directory full of files into a single prompt for use with LLMs
      # https://github.com/simonw/files-to-prompt/
      pkgs.files-to-prompt

      # A CLI tool that converts your codebase into a single LLM prompt
      # https://github.com/mufeedvh/code2prompt
      pkgs.code2prompt

      # Open-source, extensible AI agent that goes beyond code suggestions -
      # install, execute, edit, and test with any LLM
      # https://github.com/block/goose
      pkgs.goose-cli
    ];
  };
}
