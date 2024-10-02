let
  devices = {
   # Kent
    greatblue = {
      ip = "192.168.0.11";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaDZyL98bjRWgVqI2xYKckBy05G3fDIh0Prw4VYz13Q";
    };
    samsung_s24 = {
      ip = "192.168.0.70";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1SOk+WGYv+LMAt8bdJfnKQG5eHHqcBUYbjeJw4Sflp";
    };
    lenovo_y700 = {
      ip = "192.168.0.76";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWYKagP49LAsaW7j+2fVpi/x59jb/mUM2eKb/o9CC+L";
    };
    cubot_p80 = {
      ip = "192.168.0.10";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICesN2TeB/G9G7DwRsTI+QSZDmFqnh0dZxiDATlUHSF/";
    };
    boox_air_nova_c = {
      ip = "192.168.0.73";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKZDK5hEVMpb35Eanw/7zct8selZTgMtzwak92GdYg0";
    };
    hisense_a9 = {
      ip = "192.168.0.78";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuW5WWczdzTId3AZ6gPKTKa4y+5jYPownSvYx+nyC/d";
    };

    # Jess
    cichlid = {
      ip = "192.168.0.21";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDTbos7tHfhXlbGSg4l4j6AtT/9+xKtX6+6JANkndht";
    };

    # Servers
    delaware = {
      ip = "192.168.0.46";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZ2xTcSdudbG+E3z7ebHHxVJ4MiN/euWYzZ9RsTonGR";
    };
    lagurus = {
      ip = "192.168.0.65";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6IG1FP+yFHuGcBK8DavEYlc1jvaog/aztJMAP38bQv";
    };
    jerboa = {
      ip = "192.168.0.32";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoQeclOZSjy9K8lPvdz/38WU/INxMGuecfFf47X5pGj";
    };
    sebright_bantam = {
      ip = "192.168.0.80";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnBdFqtIA/MRYb7Wtmp7xxn7l4M0Fc09JkUMw3665Ua";
    };
  };
in
  devices
