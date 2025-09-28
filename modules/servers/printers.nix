{ lib, pkgs, config, ... }:
let
  cfg = config.servers.print;
in
{
  options.servers.print = with lib; {
    enable = mkEnableOption "Enable CUPS print server for hosting printers on the local network.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Cups-filters for printing PNG to Dymo XL4
      cups-filters
      lprint
      cups-printers
    ];

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser pkgs.cups-dymo ];
      webInterface = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      browsed.enable = true;
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name = "Brother_HL-L2300D";
          location = "Chicken Coop";
          deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878K7N171253";
          ppdOptions = {
             PageSize = "A4";
          };
          model = "drv:///brlaser.drv/brl2300d.ppd";
        }
        {
          name = "DYMO_LabelWriter_4XL";
          location = "Chicken Coop";
          deviceUri = "usb://DYMO/LabelWriter%204XL?serial=16102622140932";
          model = "${pkgs.cups-dymo}/share/cups/model/lw4xl.ppd";
        }
      ];
    };
  };
}
