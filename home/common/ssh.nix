{ ... }:
let
  devices = import ../../modules/devices.nix;
  knownHostsContent = builtins.concatStringsSep "\n" (map (device: "${device.ip} ${device.key}") (builtins.attrValues devices.devices));
in
{
  home.file.".ssh/known_hosts" = {
    enable = true;
    text = knownHostsContent;
  };
}
