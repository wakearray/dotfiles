{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  glib,
  accountsservice,
  gtklock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-virtkb-module";
  version = "2025-02-26";

  src = fetchFromGitHub {
    owner = "progandy";
    repo = "gtklock-virtkb-module";
    rev = "a11c2d8f14a79f271b02711b38220f927bc7fdf8";
    hash = "sha256-+kEv5SlMINCORQQOOZ4Lb1dSJXLCbX2oAsD6NTbuhdE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    glib
    accountsservice
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests.testModule = gtklock.testModule finalAttrs.finalPackage;

  meta = {
    description = "Gtklock module adding a virtual keyboard to the lockscreen";
    homepage = "https://github.com/progandy/gtklock-virtkb-module";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
