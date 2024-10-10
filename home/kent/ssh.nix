{ ... }:
{
  # Enable ssh and set its config
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        user = "kent";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
