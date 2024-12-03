{ pkgs, outputs, ... }:
{
  # nixpkgs allow unfree with stable overlay.
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      outputs.overlays.modifications
      outputs.overlays.additions
    ];
    config = { allowUnfree = true; };
  };

  nix = {
    package = pkgs.lix;
    # Weekly garbage collection
    gc = {
      automatic = true;
      frequency = "weekly";
    };
    # The contents of the nix.conf file
    # Not needed when using lix
#    settings = {
#      experimental-features = [ "nix-command" "flakes" ];
#      accept-flake-config = true;
#      auto-optimise-store = true;
#      fallback = true;
#      max-jobs = "auto";
#      download-buffer-size = 268435456;
#    };
  };
}
