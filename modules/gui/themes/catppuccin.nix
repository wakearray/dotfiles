{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Bootloader.
  boot = {
    plymouth = { 
      enable = true;
      catppuccin = { 
        enable = true; 
        flavor = "macchiato";
      };
    };
  };

  catppuccin = { 
    enable = true;
    accent = "mauve";
    flavor = "macchiato";
  };

  console.catppuccin = { 
    enable = true;
    flavor = "macchiato";
  };
}
