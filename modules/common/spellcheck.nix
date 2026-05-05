{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # aspell - english spellcheck
    stable.aspell
    stable.aspellDicts.en
    stable.aspellDicts.en-computers
    stable.aspellDicts.en-science
  ];
}
