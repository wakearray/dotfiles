{ pkgs, lib, config, ... }:
let
  hoas = config.server.home-assistant;
  bridgeName = hoas.bridge.name;
in
{
  server.home-assistant.installer = lib.mkIf hoas.enable ( pkgs.writeTextFile {
    name = "install-home-assistant";
    text = /*bash*/ ''
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
    --name haos \
    --description "Home Assistant OS" \
    --os-variant=generic \
    --memory=4096 \
    --cpu host-model \
    --vcpus=2 \
    # --disk "$HOAS_OVA_QCOW2",bus=scsi \
    --disk "/var/lib/haos/haos_ova-16.1.qcow2",bus=scsi \
    --controller type=scsi,model=virtio-scsi \
    --import \
    --graphics none \
    --boot uefi \
    # --network bridge="${bridgeName}"
    --network bridge="br0"

    '';
    executable = true;
    destination = "/bin/install-home-assistant";
  });
}
