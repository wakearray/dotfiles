let
  devices = {
    hosts = {
      greatblue = {
        ip = "192.168.0.11";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3i/PTZZawxIkgKeKl6SBpIbk5MIhPbbCV+Rt2XdVJm";
        hosts = [ "samsung_s24" "lenovo_y700" "cubot_p80" ];
        users = [ "kent" ];
      };
      starling = {
        ip = "192.168.0.143";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWchC4fFOM4ulE9YjQF2T0M/j8NSpqelnUoVgXK02cb";
        hosts = [ "samsung_s24" "lenovo_y700" "cubot_p80" "kent-greatblue" ];
        users = [ "kent" ];
      };
      cichlid = {
        ip = "192.168.0.21";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDTbos7tHfhXlbGSg4l4j6AtT/9+xKtX6+6JANkndht";
        hosts = [ "kent-greatblue" "samsung_s24" "lenovo_y700" "jess-shoebill" ];
        users = [ "kent" "jess" ];
      };
      shoebill = {
        ip = "192.168.0.21";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGbcinCfjH5E5ZHFcrAVF1XFh3BzeEItEPUPgJLqaoW";
        hosts = [ "kent-greatblue" "samsung_s24" "lenovo_y700" "jess-shoebill" ];
        users = [ "kent" "jess" ];
      };

      # Servers
      delaware = {
        ip = "192.168.0.46";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyh4x/us/WXIsqGjbfOCIKKX50mEyYg37ZMJ9VW7nnN";
        hosts = [ "kent-greatblue" "samsung_s24" "lenovo_y700" "cubot_p80" "starling" ];
        users = [ "kent" ];
      };
      lagurus = {
        ip = "192.168.0.65";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6IG1FP+yFHuGcBK8DavEYlc1jvaog/aztJMAP38bQv";
        hosts = [ "kent-greatblue" "starling" "samsung_s24" "lenovo_y700" "cubot_p80" "boox_air_nova_c" "hisense_a9" "cichlid" "jess-shoebill" ];
        users = [ "kent" "entertainment" ];
      };
      jerboa = {
        ip = "192.168.0.32";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoQeclOZSjy9K8lPvdz/38WU/INxMGuecfFf47X5pGj";
        hosts = [ "kent-greatblue" "starling" "samsung_s24" "lenovo_y700" "cubot_p80" "boox_air_nova_c" "hisense_a9" "cichlid" "jess-shoebill" ];
        users = [ "kent" "entertainment" ];
      };
      sebright_bantam = {
        ip = "192.168.0.80";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnBdFqtIA/MRYb7Wtmp7xxn7l4M0Fc09JkUMw3665Ua";
        hosts = [ "kent-greatblue" "starling" "samsung_s24" "lenovo_y700" "cubot_p80" "boox_air_nova_c" "hisense_a9" "cichlid" "jess-shoebill" ];
        users = [ "kent" ];
      };
    };

    userDevices = {
      kent = {
        greatblue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOGhJ+3+JajosnhJOFOg0Q202XigcatIgHIWqVdJr1O";
        samsung_s24 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1SOk+WGYv+LMAt8bdJfnKQG5eHHqcBUYbjeJw4Sflp";
        lenovo_y700 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWYKagP49LAsaW7j+2fVpi/x59jb/mUM2eKb/o9CC+L";
        cubot_p80 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICesN2TeB/G9G7DwRsTI+QSZDmFqnh0dZxiDATlUHSF/";
        boox_air_nova_c = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKZDK5hEVMpb35Eanw/7zct8selZTgMtzwak92GdYg0";
        hisense_a9 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuW5WWczdzTId3AZ6gPKTKa4y+5jYPownSvYx+nyC/d";
      };
      jess = {
        shoebill = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGbcinCfjH5E5ZHFcrAVF1XFh3BzeEItEPUPgJLqaoW";
        cichlid = "";
        boox_tab_c_pro = "";
      };
    };

    externalHosts = {
      # Just here so it gets added to the known_hosts file automatically
      # When connecting for the first time to a new server use the command:
      # `ssh-keyscan <url>` to print the keys.
      github = {
        ip = "github.com";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab = {
        ip = "gitlab.com";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
  };
in
  devices
