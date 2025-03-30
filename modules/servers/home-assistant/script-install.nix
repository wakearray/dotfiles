{ lib, config, ... }:
let
  home-assistant = config.servers.home-assistant;
  bridgeName = home-assistant.bridge.name;
in
{
  # /modules/servers/home-assistant/script-install
  config = lib.mkIf home-assistant.enable {
    haos-installer = lib.writeTextFile {
      name = "install-home-assistant";
      text = /* bash */ ''
#!/usr/bin/env bash

mkdir /tmp/haos-installer/
cd /tmp/haos-installer/
# Create a shell with jq and wget
# Download the latest ova qcow2 release
nix-shell --command "wget \$(wget -q -O - 'https://api.github.com/repos/home-assistant/operating-system/releases/latest' | jq -r '.assets[] | select(.name|test(\"haos_ova-[0-9.]+.qcow2.xz\")).browser_download_url')" -p jq wget

# Find last downloaded qcow2.xz file
HOAS_OVA_QCOW2_XZ="$(ls -t modified | grep "haos_ova-[0-9.]\+.qcow2.xz" | head -n1)"

# Extract qcow2.xz file
xz -d $HOAS_OVA_QCOW2_XZ
rm $HOAS_OVA_QCOW2_XZ

# Create variable for qcow2 file
HOAS_OVA_QCOW2="''${HOAS_OVA_QCOW2_XZ/%.xz/}"

set -e

virt-install \
    --connect qemu:///system \
    --name haos \
    --os-variant=generic \
    --boot uefi \
    --import \
    --disk $HOAS_OVA_QCOW2 \
    --cpu host \
    --vcpus 2 \
    --memory 4098 \
    --network network=${bridgeName} \
    --graphics none

rm $HOAS_OVA_QCOW2
      '';
      executable = true;
      destination = "/bin/install-home-assistant";
    };
  };
}
