{ ... }:
{
  imports = [
    ./sshfs.nix
  ];

  users.users.kent = {
    isNormalUser = true;
    description = "Kent";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "samba" "userdata" "storage" "vboxusers" "aria2" "docker" "input" "steamapps" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    #hashedPasswordFile = ;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBqoI7me+VjJ8IBJdqBiW4jJ2nyf98IcRPfoV8V4002" # Bitwarden stored key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjMJxmbuWJRmhB9zSa7jyz2v5+3ie9hr8ik8udoPyZ7" # Starling
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOGhJ+3+JajosnhJOFOg0Q202XigcatIgHIWqVdJr1O" # Great Blue
    ];
  };
  gui._1pass.polkitPolicyOwners = [ "kent" ];
}
