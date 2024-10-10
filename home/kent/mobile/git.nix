{ ... }:
{
  programs.git = {
    userName = "Kent Hambrock";
    userEmail = "kent.hambrock@gmail.com";
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh = {
          allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };
      user.signingkey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
    };
  };

  home.file.".ssh/allowed_signers" = {
    text = "kent.hambrock@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
    enable = false;
  };
}
