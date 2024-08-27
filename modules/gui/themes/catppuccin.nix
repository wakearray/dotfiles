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

  services.displayManager.sddm.catppuccin = { 
    enable = true;
    flavor = "macchiato";
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

  environment.systemPackages = [(
    pkgs.catppuccin-sddm.override {
      flavor = "macchiato";
      #background = "${./wallpaper.png}";
      loginBackground = true;
    }
  )];

  displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };
}
