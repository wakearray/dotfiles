{ config, lib, ... }:
let
  user = "kent";
  cfg = config.sshfsMountsKent;
in
{
  options.sshfsMountsKent = with lib; {
    enable = mkEnableOption "Enable sshfs mount points for user kent.";
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/mnt/shares/${user}" = {
        device = "${user}@192.168.0.46:/data/userdata/${lib.toSentenceCase user}";
        fsType = "sshfs";
        options = [
          "nodev"
          "noatime"
          "allow_other"
          "IdentityFile=/home/${user}/.ssh/id_ed25519"
        ];
      };
      "/mnt/shares/family" = {
        device = "${user}@192.168.0.46:/data/userdata/Family";
        fsType = "sshfs";
        options = [
          "nodev"
          "noatime"
          "allow_other"
          "IdentityFile=/home/${user}/.ssh/id_ed25519"
        ];
      };
      "/mnt/shares/public" = {
        device = "${user}@192.168.0.46:/data/userdata/public";
        fsType = "sshfs";
        options = [
          "nodev"
          "noatime"
          "allow_other"
          "IdentityFile=/home/${user}/.ssh/id_ed25519"
        ];
      };
    };
  };
}
