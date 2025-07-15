{ lib, config, ... }:
let
  nft = config.servers.firewall.nftables;
in
{
  options.servers.firewall.nftables = with lib; {
    enable = mkEnableOption "Enable an opinionated nftables config.";
  };

  config = lib.mkIf nft.enable {
    # https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=networking.nftables
    networking.nftables = {
      enable = true;
    };
    # Manually disable docker's iptables implementation
    # so it doesn't have errors after enabling nftables
    # https://github.com/NixOS/nixpkgs/issues/24318#issuecomment-289216273
    virtualisation.docker.extraOptions = "--iptables=false --ip6tables=false";
  };
}
