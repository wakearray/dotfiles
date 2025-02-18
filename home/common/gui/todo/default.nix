{ lib, config, pkgs, systemDetails, ... }:
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
    ] ++ (if builtins.match "x86_64-linux" systemDetails.architecture != null
        then with pkgs; [
          # Typescript based GUI for todo.txt files
          sleek-todo
        ]
      else [ ]);
  };
}
