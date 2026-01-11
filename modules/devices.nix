let
  devices = {
    # Kent
    greatblue = {
      prettyName = "Great Blue";
      ip = "192.168.0.11";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3i/PTZZawxIkgKeKl6SBpIbk5MIhPbbCV+Rt2XdVJm";
      description = "GPD Win Max 2 2023";
      users = [ "kent" ];
    };
    starling = {
      prettyName = "Starling";
      ip = "192.168.0.143";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWchC4fFOM4ulE9YjQF2T0M/j8NSpqelnUoVgXK02cb";
      description = "SZBOX 7in Tablet/Surface NUC 1";
      users = [ "kent" ];
    };
    samsungs24 = {
      prettyName = "S24 Ultra";
      ip = "192.168.0.70";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1SOk+WGYv+LMAt8bdJfnKQG5eHHqcBUYbjeJw4Sflp";
      description = "Samsung Galaxy S24 Ultra";
      users = [ "kent" ];
    };
    lenovoy700 = {
      prettyName = "Lenovo Y700";
      ip = "192.168.0.76";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWYKagP49LAsaW7j+2fVpi/x59jb/mUM2eKb/o9CC+L";
      description = "Lenovo Y700 Android Tablet";
      users = [ "kent" ];
    };
    cubotp80 = {
      prettyName = "Cubot P80";
      ip = "192.168.0.10";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICesN2TeB/G9G7DwRsTI+QSZDmFqnh0dZxiDATlUHSF/";
      description = "Cubot P80";
      users = [ "kent" ];
    };
    booxairnovac = {
      prettyName = "Boox Air Nova C";
      ip = "192.168.0.73";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKZDK5hEVMpb35Eanw/7zct8selZTgMtzwak92GdYg0";
      description = "Boox Air Nova C";
      users = [ "kent" ];
    };
    hisensea9 = {
      prettyName = "Hisense A9";
      ip = "192.168.0.78";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuW5WWczdzTId3AZ6gPKTKa4y+5jYPownSvYx+nyC/d";
      description = "Hisense A9 Eink Phone";
      users = [ "kent" ];
    };
    # TODO
    # bigmehibreakcolor

    # Jess
    cichlid = {
      prettyName = "Cichlid";
      ip = "192.168.0.21";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDTbos7tHfhXlbGSg4l4j6AtT/9+xKtX6+6JANkndht";
      description = "Jess' gaming desktop";
      users = [ "kent" "jess" ];
    };
    shoebill = {
      prettyName = "Shoebill";
      ip = "192.168.0.21";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGbcinCfjH5E5ZHFcrAVF1XFh3BzeEItEPUPgJLqaoW";
      description = "Valve Steam Deck";
      users = [ "kent" "jess" ];
    };

    # Servers
    delaware = {
      prettyName = "Delaware";
      ip = "192.168.0.46";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyh4x/us/WXIsqGjbfOCIKKX50mEyYg37ZMJ9VW7nnN";
      description = "Dell Optiplex Server";
      users = [ "kent" ];
    };
    moonfish = {
      prettyName = "Moonfish";
      ip = "192.168.0.166";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7jTRj4EwVd6jenHGMHJICVPA5aC/ZAVuguicQxknn1";
      description = "Minisforum BD795iSE based game streaming server with Nvidia GTX 1080";
      users = [ "kent" "jess" ];
    };
    hamburger = {
      prettyName = "Hamburger";
      ip = "5.161.77.151";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFATH54Utcx9Ia4PwjF2D0p4OiLIGxw55K1QqU4eV328";
      description = "Low end Hetzner VPS";
      users = [ "kent" ];
    };
    lagurus = {
      prettyName = "Lagurus";
      ip = "192.168.0.65";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6IG1FP+yFHuGcBK8DavEYlc1jvaog/aztJMAP38bQv";
      description = "Cat projector computer";
      users = [ "kent" "entertainment" ];
    };
    jerboa = {
      prettyName = "Jerboa";
      ip = "192.168.0.32";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoQeclOZSjy9K8lPvdz/38WU/INxMGuecfFf47X5pGj";
      description = "HTPC";
      users = [ "kent" "entertainment" ];
    };
    sebrightbantam = {
      prettyName = "Sebright Bantam";
      ip = "192.168.0.80";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnBdFqtIA/MRYb7Wtmp7xxn7l4M0Fc09JkUMw3665Ua";
      description = "QNAP TS-251";
      users = [ "kent" ];
    };
    homeassistant = {
      prettyName = "Home Assistant";
      ip = "192.168.0.138";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjtTzTujCfgpjoI+OHgcOSwVLOMi6IQnei7Rx3z2twL";
      description = "Hardkernel Odroid HC4";
      users = [ "kent" ];
    };

    # Just here so it gets added to the knownhosts file automatically
    # When connecting for the first time to a new server use the command:
    # `ssh-keyscan <url>` to print the keys.
    github = {
      prettyName = "GitHub";
      ip = "github.com";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      users = [ "github" ];
    };
    gitlab = {
      prettyName = "GitLab";
      ip = "gitlab.com";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      users = [ "gitlab" ];
    };
  };
in
  devices
