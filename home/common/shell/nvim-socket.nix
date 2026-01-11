{ lib, config, ... }:
{
  config = {
    home = {
      file.".local/bin/nvim-socket" = {
        enable = true;
        force = true;
        executable = true;
        text = /*bash*/ ''
#!/usr/bin/env bash

nvim --listen /tmp/nvim-socket-$(eval uuidgen) "$@"
        '';
      };
    };
  };
}
