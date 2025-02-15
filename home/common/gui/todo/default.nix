{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  todo = gui.todo;
in
{
  imports = [
    ./todofi.nix
    ./config.nix
  ];

  options.gui.todo = with lib; {
    enable = mkEnableOption "Enable an opinionated todo.txt config.";
  };

  config = lib.mkIf (gui.enable && todo.enable) {
    home.packages = with pkgs; [
      # todo.txt cli interface
      todo-txt-cli

      # Typescript based GUI for todo.txt files
      sleek-todo
    ];
  };
}
