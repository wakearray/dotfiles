{ lib, pkgs, system-details, ... }:
{
  config = lib.mkIf (builtins.match "laptop" system-details.host-type != null) {
    environment.systemPackages = with pkgs; [
      brightnessctl
      acpi
    ];

    services.acpid = {
      enable = true;

      # Description: Event handlers. Handler can be a single command.
      # Type: attribute set of (submodule)
      #handlers = {
      #  # Whatever name you want
      #  ac-power = {
      #    # Actions are just shell scripts to execute when event is triggered.
      #    action = ''
      #      vals=($1)  # space separated string to array of multiple values
      #      case ''${vals[3]} in
      #        00000000)
      #          echo unplugged >> /tmp/acpi.log
      #          ;;
      #        00000001)
      #          echo plugged in >> /tmp/acpi.log
      #          ;;
      #        *)
      #          echo unknown >> /tmp/acpi.log
      #          ;;
      #      esac
      #    '';
      #    # Possible Events:
      #    # "button/power.*" "button/lid.*" "ac_adapter.*" "button/mute.*" "button/volumedown.*" "cd/play.*" "cd/next.*"
      #    event = "ac_adapter/*";
      #  };
      #};
    };
  };
}
