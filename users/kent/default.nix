{ lib, ... }:
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
    ./sshfs.nix
  ];

  users.users.kent = {
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "samba" "userdata" "storage" "vboxusers" "aria2" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    #hashedPasswordFile = ;
    openssh.authorizedKeys.keys = userKeys;
  };
  nix.settings.trusted-users = [ "kent" ];
  gui._1pass.polkitPolicyOwners = [ "kent" ];
}
