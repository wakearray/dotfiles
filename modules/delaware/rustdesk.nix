{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
   # Rustdesk-Server
   services.rustdesk-server = {
     enable = true;
     openFirewall = true;
     relayIP = "23.16.17.118";
     package = pkgs.unstable.rustdesk-server;
   };
}
