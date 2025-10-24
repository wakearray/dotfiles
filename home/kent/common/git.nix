{ ... }:
{
  programs.git = {
    settings = {
      user = {
        email = "kent.hambrock@gmail.com";
        name = "Kent Hambrock";
        signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
      };
    };
    includes = [
      { # Forgejo
        contents = {
          user = {
            email = "kent.hambrock@gmail.com";
            name = "Kent";
            signingKey =
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS7V7ws9gPd3suTPJqs3k7L9EKvZR0Kxtxdi1DYvMl4";
          };
        };
        condition = "hasconfig:remote.*.url:https://git.voicelesscrimson.com";
      }
    ];
  };
}
