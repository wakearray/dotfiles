{ config, ... }:

let
  # Function to convert a string to lowercase
  toLower = str: builtins.replaceStrings (builtins.attrNames builtins.toUpper) (builtins.attrValues builtins.toLower) str;

  # Get the hostname from the NixOS configuration and convert it to lowercase, using a default if not set
  hostname = toLower (config.networking.hostname or "default");

  # Check if a directory with the hostname exists
  hostDir = ./${hostname};
in
  if builtins.pathExists hostDir then
    import hostDir
  else
    {}  # Return an empty set or a default configuration
