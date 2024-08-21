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
     relay-IP = "23.16.17.118";
     package = pkgs.unstable.rustdesk-server;
   };
}
