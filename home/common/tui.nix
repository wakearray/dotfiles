{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tui for controlling wifi
    impala
    # tui for managing LLMs
    tenere
  ];
}
