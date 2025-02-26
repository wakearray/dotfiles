{ ... }:
{
  # Fingerprint reader now has a driver:
  # https://github.com/ericlinagora/libfprint-CS9711
  # will not build
#  services.fprintd.enable = true;
#  nixpkgs.overlays = [
#    (final: prev: {
#      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
#        version = "git";
#        src = final.fetchFromGitHub {
#          owner = "ericlinagora";
#          repo = "libfprint-CS9711";
#          rev = "c242a40fcc51aec5b57d877bdf3edfe8cb4883fd";
#          sha256 = "sha256-WFq8sNitwhOOS3eO8V35EMs+FA73pbILRP0JoW/UR80=";
#        };
#        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
#          final.opencv
#          final.cmake
#          final.doctest
#        ];
#      });
#    })
#  ];

  # Trying to prevent the fingerprint reader from blocking resume from suspend-to-ram
  # Only occasionally works
  boot.kernelParams = [ "drm_kms_helper.poll=N" "usbcore.autosuspend=-1" ];

  # Udev rule to disable the driverless fingerprint reader
  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0"
  '';
}
