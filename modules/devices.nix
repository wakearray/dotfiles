let
  devices = {
    # Kent
    kent-greatblue = {
      ip = "192.168.0.11";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOGhJ+3+JajosnhJOFOg0Q202XigcatIgHIWqVdJr1O";
      hosts = [ "samsungs24" "lenovoy700" "cubotp80" "kent-starling" ];
      users = [ "kent" ];
    };
    kent-starling = {
      ip = "192.168.0.143";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjMJxmbuWJRmhB9zSa7jyz2v5+3ie9hr8ik8udoPyZ7";
      hosts = [ "samsungs24" "lenovoy700" "cubotp80" "kent-greatblue" ];
      users = [ "kent" ];
    };
    greatblue = {
      ip = "192.168.0.11";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3i/PTZZawxIkgKeKl6SBpIbk5MIhPbbCV+Rt2XdVJm";
      hosts = [ "samsungs24" "lenovoy700" "cubotp80" "kent-starling" ];
      users = [ "kent" ];
    };
    starling = {
      ip = "192.168.0.143";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWchC4fFOM4ulE9YjQF2T0M/j8NSpqelnUoVgXK02cb";
      hosts = [ "samsungs24" "lenovoy700" "cubotp80" "kent-greatblue" ];
      users = [ "kent" ];
    };
    samsungs24 = {
      ip = "192.168.0.70";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1SOk+WGYv+LMAt8bdJfnKQG5eHHqcBUYbjeJw4Sflp";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "cubotp80" ];
      users = [ "kent" ];
    };
    lenovoy700 = {
      ip = "192.168.0.76";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWYKagP49LAsaW7j+2fVpi/x59jb/mUM2eKb/o9CC+L";
      hosts = [ "kent-greatblue" "samsungs24" "cubotp80" ];
      users = [ "kent" ];
    };
    cubotp80 = {
      ip = "192.168.0.10";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICesN2TeB/G9G7DwRsTI+QSZDmFqnh0dZxiDATlUHSF/";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" ];
      users = [ "kent" ];
    };
    booxairnovac = {
      ip = "192.168.0.73";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKZDK5hEVMpb35Eanw/7zct8selZTgMtzwak92GdYg0";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "cubotp80" ];
      users = [ "kent" ];
    };
    hisensea9 = {
      ip = "192.168.0.78";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuW5WWczdzTId3AZ6gPKTKa4y+5jYPownSvYx+nyC/d";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "cubotp80" ];
      users = [ "kent" ];
    };
    # TODO
    # bigmehibreakcolor

    # Jess
    cichlid = {
      ip = "192.168.0.21";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDTbos7tHfhXlbGSg4l4j6AtT/9+xKtX6+6JANkndht";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "jess-shoebill" ];
      users = [ "kent" "jess" ];
    };
    jess-shoebill = {
      ip = "192.168.0.21";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGbcinCfjH5E5ZHFcrAVF1XFh3BzeEItEPUPgJLqaoW";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "cichlid" ];
      users = [ "kent" "jess" ];
    };

    # Servers
    delaware = {
      ip = "192.168.0.46";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyh4x/us/WXIsqGjbfOCIKKX50mEyYg37ZMJ9VW7nnN";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "cubotp80" "kent-starling" ];
      users = [ "kent" ];
    };
    hamburger = {
      ip = "5.161.77.151";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFATH54Utcx9Ia4PwjF2D0p4OiLIGxw55K1QqU4eV328";
      hosts = [ "kent-greatblue" "samsungs24" "lenovoy700" "cubotp80" "kent-starling" ];
      users = [ "kent" ];
    };
    lagurus = {
      ip = "192.168.0.65";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6IG1FP+yFHuGcBK8DavEYlc1jvaog/aztJMAP38bQv";
      hosts = [ "kent-greatblue" "starling" "samsungs24" "lenovoy700" "cubotp80" "booxairnovac" "hisensea9" "cichlid" "jess-shoebill" ];
      users = [ "kent" "entertainment" ];
    };
    jerboa = {
      ip = "192.168.0.32";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoQeclOZSjy9K8lPvdz/38WU/INxMGuecfFf47X5pGj";
      hosts = [ "kent-greatblue" "starling" "samsungs24" "lenovoy700" "cubotp80" "booxairnovac" "hisensea9" "cichlid" "jess-shoebill" ];
      users = [ "kent" "entertainment" ];
    };
    sebrightbantam = {
      ip = "192.168.0.80";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnBdFqtIA/MRYb7Wtmp7xxn7l4M0Fc09JkUMw3665Ua";
      hosts = [ "kent-greatblue" "starling" "samsungs24" "lenovoy700" "cubotp80" "booxairnovac" "hisensea9" "cichlid" "jess-shoebill" ];
      users = [ "kent" ];
    };

    # Just here so it gets added to the knownhosts file automatically
    # When connecting for the first time to a new server use the command:
    # `ssh-keyscan <url>` to print the keys.
    github = {
      ip = "github.com";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      hosts = [ "github" ];
      users = [ "github" ];
    };
    gitlab = {
      ip = "gitlab.com";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      hosts = [ "gitlab" ];
      users = [ "gitlab" ];
    };
  };
in
  devices
