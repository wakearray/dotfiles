{ inputs,
  outputs,
  lib,
  config,
  pkgs,
  domain,
  secrets,
  ... }:
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

    # Game servers
    ./satisfactory.nix
  ];

  # Where needed:
  # {secrets, domain, ...}:
  # {
  #   secrets = "/etc/nixos/secrets";
  #   domain = "voicelesscrimson.com";
  # }

  services.satisfactory = { enable = true; };
}
