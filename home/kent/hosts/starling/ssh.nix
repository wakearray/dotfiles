{ ... }:
{
  config = {
    programs.ssh = {
      matchBlocks = {
        # Hetzner - Hamburger
        "5.161.77.151" = {
          user = "root";
          identityFile = "~/.ssh/hetzner_root_2023_ed25519.pub";
          identitiesOnly = true;
        };
      };
    };
  };
}
