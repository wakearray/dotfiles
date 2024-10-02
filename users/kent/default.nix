{ ... }:
let
  devices = import ../../modules/devices.nix;
in
{
  users.users.kent = {
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "samba" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    openssh.authorizedKeys.keys = with devices; [
      greatblue.key samsung_s24.key lenovo_y700.key cubot_p80.key boox_air_nova_c.key hisense_a9.key
    ];
  };
}
