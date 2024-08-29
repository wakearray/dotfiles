{ inputs,
  outputs,
  pkgs, ... }:
let
  sshkeys = import ../../secrets/sshkeys.nix;
in
{
  users.users.jess = {
    isNormalUser = true;
    description = "Jess";
    extraGroups = [ "networkmanager" "wheel" "samba" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    openssh.authorizedKeys.keys = with sshkeys; [
      greatblue cichlid
    ];
  };
}
