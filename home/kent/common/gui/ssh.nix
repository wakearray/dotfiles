{ ... }:
{
  config = {
    programs.ssh = {
      matchBlocks = {
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
