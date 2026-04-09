{ ... }:
{
  users.users.jess = {
    isNormalUser = true;
    description = "Jess";
    extraGroups = [ "networkmanager" "wheel" "samba" "userdata" "storage" "aria2" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    #hashedPasswordFile = ;
  };
  gui._1pass.polkitPolicyOwners = [ "jess" ];
}
