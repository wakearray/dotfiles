{ ... }:
{
  config = {
    programs.ssh = {
      matchBlocks = {
        # Hetzner - Hamburger
        "5.161.77.151" = {
          user = "root";
          identityFile = "~/.ssh/hetzner_root_2023_ed25519";
          identitiesOnly = true;
        };
        # Forgejo key
        "git.voicelesscrimson.com" = {
          user = "forgejo";
          identityFile = "~/.ssh/forgejo_ed25519";
          identitiesOnly = true;
        };
      };
    };
  };
}
