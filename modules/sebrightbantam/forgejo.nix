{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Forgejo
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.localhost";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "localhost";
        PROTOCOL = "http";
        HTTP_PORT = 8065;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };
}
