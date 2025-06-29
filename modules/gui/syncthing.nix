{ lib, config, ... }:
let
  gui = config.gui;
  syncthing = gui.syncthing;

  titleCase = str: (lib.toUpper (builtins.substring 0 1 str)) + (lib.toLower (builtins.substring 1 32 str));
  hostname = lib.toLower config.modules.systemDetails.hostName;
in
{
  # /modules/gui/syncthing.nix
  options.gui.syncthing = with lib; {
    enable = mkEnableOption "Enable a *very* opinionated Syncthing config.";

    user = mkOption {
      type = types.str;
      default = "kent";
      description = "The name of the user to sync.";
    };

    sopsFile = mkOption {
      type = types.path;
      default = ./syncthing.yaml;
      description = "The relative location of the yaml file containing the secrets.";
    };
  };

  config = lib.mkIf (gui.enable && syncthing.enable) {
    # Syncthing, a file syncing service
    #
    # Use the command `nix-shell -p syncthing --run "syncthing generate --config myconfig/"`
    # to generate a new ID and certs for a new machine.
    services.syncthing = {
      enable = true;
      key = "/run/secrets/${hostname}-syncthing-key-pem";
      cert = "/run/secrets/${hostname}-syncthing-cert-pem";
      user = syncthing.user;
      settings = lib.mkDefault {
        folders =
        let
          titleUser = titleCase syncthing.user;
        in
        {
          # Name of folder in Syncthing, also the folder ID
          "Family_Notes" = {
            # Which folder to add to Syncthing
            path = "/home/${syncthing.user}/notes/family/";
            devices = [ "Delaware" ];
          };
          "Shared_Development" = {
            # Which folder to add to Syncthing
            path = "/home/${syncthing.user}/Shared Development/";
            devices = [ "Delaware" ];
          };
          "${titleUser}_Notes" = {
            path = "/home/${syncthing.user}/notes/personal/";
            devices = [ "Delaware" ];
          };
          "${titleUser}_Backup_Android" = {
            path = "/home/${syncthing.user}/Backups/Android/";
            devices = [ "Delaware" ];
          };
          "${titleUser}_Backup_PC" = {
            path = "/home/${syncthing.user}/Backups/PC/";
            devices = [ "Delaware" ];
          };
        };
      };
    };

    sops.secrets = let
      opts = {
        sopsFile = syncthing.sopsFile;
        mode     = "0400";
        owner    = syncthing.user;
        group    = "users";
      };
    in
    {
      "${hostname}-syncthing-key-pem" = opts;
      "${hostname}-syncthing-cert-pem" = opts;
    };
  };
}
