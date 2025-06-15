{ ... }:
{
  programs = {
    git = {
      enable = true;
      config = [
        { init = { defaultBranch = "main"; }; }
        { user = {
          name = "DemureShoebill";
          email = "jessbriannehambrock@gmail.com";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHavZOIdpZYCzTwmY9h9rrh+zFnhLmwUzZZwHpgtOolg";
        };}
        { gpg = { format = "ssh"; }; }
        { commit = { gpgsign = true; }; }
        { color = { ui = "auto"; }; }
      ];
    };
  };
}
