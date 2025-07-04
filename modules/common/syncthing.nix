{ lib, config, pkgs, ... }:
{
  # /modules/common/syncthing.nix
  config = lib.mkIf config.services.syncthing.enable {
    # Makes syncthing available on the command line
    environment.systemPackages = with pkgs; [ syncthing ];

    # Don't create default ~/Sync folder
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    # Syncthing service
    services.syncthing = {
      overrideDevices  = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders  = true;     # overrides any folders added or deleted through the WebUI
      openDefaultPorts = true;
      settings = {
        #
        # Use the command `nix-shell -p syncthing --run "syncthing generate --config myconfig/"`
        # to generate a new ID and certs for a new machine.
        #
        devices = {
          "Delaware"           = { id = "NPGSSWY-NXG6AOK-2D56VX6-DEZTGFD-OZFWLNX-NMZWCYG-VT6Q4X4-OCIWPQM"; };
          "Kent_S24_Ultra"     = { id = "SD6ZVE2-JPJEKJM-I2VHZBK-A42GUPM-EGIZIG7-QKI3H5B-KG3XEPL-MDETKQZ"; };
          "Kent_P80"           = { id = "TUOYN7I-JW7FVCY-B2RJSIW-2QJD6KO-7MQ5JOY-QK5X6HA-BKSZ4KL-FGSVDQL"; };
          "Kent_y700"          = { id = "QA7LAZ2-36XZMTG-IQ6IKMK-C3RKD5O-Y5X53TV-J5NLKQM-NPOG6RU-TP7WTQE"; };
          "Kent_Boox"          = { id = "T3U4VSV-7LPWYBK-7GNDAMU-GG7IMXO-OKCFZQB-4WMC2KP-RFANMLH-FFO3WQ7"; };
          "Kent_Hisense_A9"    = { id = "S55WSYJ-K3C6MV7-YWEUAW5-YAYHAB2-FIZ7RNR-NE7KCTZ-PZNPO2I-6S3W4AT"; };
          "Kent_Hibreak_Color" = { id = "PXINNDR-CVMSSUA-GQHDX4N-BGE27NZ-MKQSN63-YGUTHG7-OTMHYI6-7JV4XAN"; };
          "Kent_GreatBlue"     = { id = "6B6CFWQ-AOVKOLS-AJ77Y7U-T5G7QPG-IQTPCSJ-NRPZNJR-4LMLIRS-FGMYSQ2"; };
          "Kent_Starling"      = { id = "SEIVFSL-BJXGTRG-RMC7X6F-NEX7VI6-2HASSWN-IYDGDCL-O3WBQL5-565PNQT"; };
          "Jess_S20_Ultra"     = { id = "F436IQN-OOP5KEX-CNCY7VA-4CKUSOR-6YUHIO2-TTESNNW-TMMSMNI-CQZNUAZ"; };
          "Jess_Cichlid"       = { id = "GS6LSCL-ANDVRKL-M3DOWQF-PIQJKUK-WB2K7FT-KOANCWV-4P5CHNF-FPJNWA2"; };
          "Jess_Shoebill"      = { id = "R2VMOYW-EQETCQR-EMZIPV2-UYOVJ4H-TCLE6EY-26CUXGY-K5XVJ7N-F27HSQF"; };
          "Jess_Boox"          = { id = "4ODHCVZ-VTS2L3D-7KS67BR-75VRWPY-4NFPJC2-XI6YZIZ-REVKEC7-3Q2CBQH"; };
        };
      };
    };
  };
}
