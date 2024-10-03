{ lib, ... }:
let
  devices = import ../../modules/devices.nix;

  # Function to extract keys for a specific user
  getKeysForUser = user:
    let
      isUserInDevice = device: lib.elem user device.users;
    in
      map (device: device.key) (lib.filter isUserInDevice (lib.attrValues devices));

  userKeys = getKeysForUser "jess";
in
{
  users.users.jess = {
    isNormalUser = true;
    description = "Jess";
    extraGroups = [ "networkmanager" "wheel" "samba" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    openssh.authorizedKeys.keys = userKeys;
  };
}
