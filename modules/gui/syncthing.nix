{ lib, config, ... }:
let
  syncthing = config.gui.syncthing;
  hostname = lib.toLower config.modules.systemDetails.hostName;
in
{
  # /modules/gui/syncthing.nix
  options.gui.syncthing = with lib; {
    enable = mkEnableOption "Enable a *very* opinionated Syncthing config.";

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The name of the user to sync.";
    };

    sopsFile = mkOption {
      type = types.path;
      default = ./syncthing.yaml;
      description = "The relative location of the yaml file containing the secrets.";
    };
  };

  config = lib.mkIf syncthing.enable {
    # Syncthing, a file syncing service
    #
    # Use the command `nix-shell -p syncthing --run "syncthing generate --config myconfig/"`
    # to generate a new ID and certs for a new machine.
    services.syncthing = {
      enable = true;
      key = "/run/secrets/${hostname}-syncthing-key-pem";
      cert = "/run/secrets/${hostname}-syncthing-cert-pem";
      user = syncthing.user;
      settings = {
        folders =
        let
          titleUser = lib.toSentenceCase syncthing.user;
        in
        {
          # Name of folder in Syncthing, also the folder ID
          "Family_Notes" = {
            enable = true;
            # Which folder to add to Syncthing
            path = "/home/${syncthing.user}/notes/family/";
            # Which devices to use for syncing
            devices = [ "Delaware" ];
            # Unless ignorePerms is set to true, Android can seemingly sometimes cause issues
            ignorePerms = true;
          };
          "Shared_Development" = {
            path = "/home/${syncthing.user}/Shared Development/";
            devices = [ "Delaware" ];
            ignorePerms = true;
          };
          "${titleUser}_Notes" = {
            path = "/home/${syncthing.user}/notes/personal/";
            devices = [ "Delaware" ];
            ignorePerms = true;
          };
          "${titleUser}_Backup_Android" = {
            path = "/home/${syncthing.user}/Backups/Android/";
            devices = [ "Delaware" ];
            ignorePerms = true;
          };
          "${titleUser}_Backup_PC" = {
            path = "/home/${syncthing.user}/Backups/PC/";
            devices = [ "Delaware" ];
            ignorePerms = true;
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
