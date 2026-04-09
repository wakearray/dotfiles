{ ... }:
{
  config = {
    programs.ssh = {
      matchBlocks = {
        wakenet = {
          match = "localnetwork 192.168.0.0/24";
          user = "kent";
          identityFile = "~/.ssh/id_ed25519_wakenet_kent_ssh.pub";
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

    home.file = {
      ".ssh/id_ed25519_wakenet_kent_ssh.pub" = {
        enable = true;
        force = true;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBqoI7me+VjJ8IBJdqBiW4jJ2nyf98IcRPfoV8V4002";
      };
      ".ssh/id_ed25519_forgejo_kent_ssh.pub" = {
        enable = true;
        force = true;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBqoI7me+VjJ8IBJdqBiW4jJ2nyf98IcRPfoV8V4002";
      };
    };
  };
}
