{ ... }:
let
  devices = import ../../modules/devices.nix;
  knownHostsContent = builtins.concatStringsSep "\n" (map (device: "${device.ip} ${device.key}") (builtins.attrValues devices));
in
{
  # Create the `known_hosts` file from a nix file
  home.file = {
    ".ssh/known_hosts" = {
      enable = true;
      text = knownHostsContent;
    };
  };

  # Enable the ssh-agent
  services.ssh-agent.enable = true;
}
