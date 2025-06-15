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
      };
      user.signingkey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
      color.ui = "auto";
      # initialize new repos using `main` for the first branch rather than `master`
      init.defaultBranch = "main";
    };
  };
}
