{ ... }:
let
  sshkeys = import ../../secrets/sshkeys.nix;
in
{
  users.users.kent = {
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "samba" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    openssh.authorizedKeys.keys = with sshkeys; [
      greatblue samsung_s24 lenovo_y700 cubot_p80 boox_air_nova_c hisense_a9
    ];
  };
}
