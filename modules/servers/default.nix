{ config, lib, ... }:
let
  devices = import ../../modules/devices.nix;

  # Function to extract keys for a specific user
  getKeysForUser = user:
    let
      isUserInDevice = device: lib.elem user device.users;
    in
      map (device: device.key) (lib.filter isUserInDevice (lib.attrValues devices));

  userKeys = getKeysForUser "kent";
in
{
  imports = [
    ./aria2
    ./audiobookshelf.nix
    ./deluge
    ./docker
    ./firewall
    ./forgejo
    ./home-assistant
    ./jellyfin.nix
    ./mailserver.nix
    ./mattermost.nix
    ./miniflux.nix
    ./ncps.nix
    ./nginx.nix
    ./paperless
    ./printers.nix
    ./satisfactory.nix
    ./webdav.nix
  ];

  config = lib.mkIf config.modules.systemDetails.isServer {
    boot.initrd.network.ssh.authorizedKeys = userKeys;
  };
}
