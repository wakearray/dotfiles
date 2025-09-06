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
      force = true;
      text = knownHostsContent;
    };
  };

  # Enable ssh and set its config
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        remoteForwards = [
          { # Lemonade
            bind.port = 2489;
            host.address = "localhost";
            host.port = 2489;
          }
        ];

        # defaults
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };

  # Enable the ssh-agent
  services.ssh-agent.enable = true;
}
