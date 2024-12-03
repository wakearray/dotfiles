{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
  # aspell - english spellcheck
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];
}
