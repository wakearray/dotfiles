{ ... }:
{
  programs.git = {
    userName = "DemureShoebill";
    userEmail = "jessbriannehambrock@gmail.com";
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
      };
      user.signingkey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHavZOIdpZYCzTwmY9h9rrh+zFnhLmwUzZZwHpgtOolg";
      color.ui = "auto";
      # initialize new repos using `main` for the first branch rather than `master`
      init.defaultBranch = "main";
    };
  };
}
