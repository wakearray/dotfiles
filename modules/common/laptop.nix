{ lib, pkgs, config, ... }:
let
  isLaptop = config.modules.systemDetails.isLaptop;
in
{
  config = lib.mkIf isLaptop {
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
		# Set up wifi
		networking.networkmanager.ensureProfiles.profiles = lib.mkIf config.networking.networkmanager.enable {
			"Wakenet" = {
				connection = {
					type = "wifi";
					id = "Wakenet";
				};
				ipv4 = {
					method = "auto";
				};
				ipv6 = {
					addr-gen-mode = "default";
					method = "auto";
				};
				wifi = {
					mode = "infrastructure";
					ssid = "Wakenet";
				};
				wifi-security = {
					auth-alg = "open";
					key-mgmt = "wpa-psk";
					psk = "sZ9YEEYPqBAfHMpcRkVP2hT8tx3gEcY";
				};
			};
		};
  };
}
