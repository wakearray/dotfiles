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
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "samba" "userdata" "storage" "vboxusers" "aria2" "docker" "input" ];
    initialHashedPassword = "$y$j9T$a09xjLjAlf/rHpCdhnAM4/$wlp6tDHeX2OfnUTXA29RWbALS5PvLc/1cpu0rZF4170";
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    #hashedPasswordFile = ;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjMJxmbuWJRmhB9zSa7jyz2v5+3ie9hr8ik8udoPyZ7" # Starling
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOGhJ+3+JajosnhJOFOg0Q202XigcatIgHIWqVdJr1O" # Great Blue
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFoZOna4AhLjJlOlHqbZSkYf+WzAgkg5KQs6yM7bAUOP" # Lenovo y700
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKZDK5hEVMpb35Eanw/7zct8selZTgMtzwak92GdYg0" # Boox Air Nova C
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICesN2TeB/G9G7DwRsTI+QSZDmFqnh0dZxiDATlUHSF/" # Cubot P80
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1SOk+WGYv+LMAt8bdJfnKQG5eHHqcBUYbjeJw4Sflp" # S24 Ultra
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuW5WWczdzTId3AZ6gPKTKa4y+5jYPownSvYx+nyC/d" # Hisense A9
    ];
  };
  nix.settings.trusted-users = [ "kent" ];
  gui._1pass.polkitPolicyOwners = [ "kent" ];
}
