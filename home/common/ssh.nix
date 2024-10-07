{ ... }:
let
  devices = import ../../modules/devices.nix;
  knownHostsContent = builtins.concatStringsSep "\n" (map (device: "${device.ip} ${device.key}") (builtins.attrValues devices.devices));
in
{
  home.file = {
    ".ssh/known_hosts" = {
      venable = true;
      text = knownHostsContent;
    };
    ".ssh/ssh_config" = {
      text = ''
Host *
  User kent
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  Port 22
      '';
    };
  };
}
