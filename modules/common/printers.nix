{ lib, pkgs, config, ... }:
let
  printers = config.modules.systemDetails.features.printers;
in
{
  config = lib.mkIf printers {
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

    #hardware.printers = {
    #  ensurePrinters = [
    #    {
    #      name = "Brother_HL-L2300D";
    #      location = "Chicken Coop";
    #      deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878K7N171253";
    #      model = "drv:///brlaser.drv/brl2300d.ppd";
    #      ppdOptions = {
    #         PageSize = "A4";
    #      };
    #    }
    #  ];
    #};

    # Open the port for the CUPs web interface
    networking.firewall.allowedTCPPorts = [ 631 ];
  };
}
