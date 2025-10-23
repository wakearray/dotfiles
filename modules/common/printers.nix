{ lib, pkgs, config, ... }:
let
  cfg = config.gui.print;
in
{
  options.gui.print = with lib; {
    enable = mkEnableOption "Enable CUPS print server for connecting to printers on the local network.";
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
    };

    ###
    ### # Instructions:
    ###
    ###  - Build sytem with required Nix Expression above
    ###  - Open terminal and start lprint server
    ###  - Open cups local server at http://localhost:631/ and modify the printer
    ###  - You’ll click next a bunch of times till you get to the drivers page.
    ###  - On the drivers page you’ll need to change the printer from generic manufacturer to dymo and then select the correct printer driver.
    ###  - After that, it’ll ask you for your login details. Login with your normal OS login and everything should work now.
    ###

    hardware.printers = {
      ensureDefaultPrinter = "Brother_HL-L2300D";
      ensurePrinters = [
        {
          name = "Brother_HL-L2300D";
          location = "Chicken Coop";
          deviceUri = "http://192.168.0.46:631/printers/Brother_HL-L2300D";
          ppdOptions = {
             PageSize = "A4";
          };
          model = "drv:///${pkgs.brlaser}/share/cups/drv/brlaser.drv/brl2300d.ppd";
        }
        {
          name = "DYMO_LabelWriter_4XL";
          location = "Chicken Coop";
          deviceUri = "http://192.168.0.46:631/printers/DYMO_LabelWriter_4XL";
          model = "${pkgs.cups-dymo}/share/cups/model/lw4xl.ppd";
        }
      ];
    };
  };
}
