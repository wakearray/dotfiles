{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    # Cups-filers for printing PNG to Dymo XL4
    cups-filters
    lprint
    cups-printers
  ];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser pkgs.cups-dymo ];
  };
}
