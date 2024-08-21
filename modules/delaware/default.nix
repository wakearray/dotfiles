{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  ## These are the defaults I want on Delaware only:
  imports =
  [
    ./audiobookshelf.nix
    ./deluge.nix
    ./docker.nix
    ./forgejo.nix
    ./mailserver.nix
    ./nextcloud.nix
    ./nginx.nix
    ./printers.nix
    ./rustdesk.nix
    ./samba.nix
    ./syncthing.nix
    ./systemd-mounts.nix
    ./zfs.nix
  ];

  # Where needed:
  # config.secrets = "/etc/nixos/secrets";
  # config.domain = "voicelesscrimson.com";
}
