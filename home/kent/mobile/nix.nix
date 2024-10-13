{ pkgs, outputs, ... }:
{
  # nixpkgs allow unfree with unstable overlay.
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
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
