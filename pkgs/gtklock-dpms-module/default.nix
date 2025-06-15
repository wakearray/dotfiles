{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  accountsservice,
  gtklock,
  wlr-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-dpms-module";
  version = "4.0.0";

  src = fetchFromSourcehut {
    owner = "~aperezdc";
    repo = "gtklock-dpms-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tiENkrgwKMfw+cCWizHTwOIkCfZ9jnONL6rkokyuxOw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wlr-protocols
    wayland-scanner
  ];

  buildInputs = [
    gtk3
    glib
    accountsservice
  ];

  passthru.tests.testModule = gtklock.testModule finalAttrs.finalPackage;

  installPhase = ''
    mkdir -p $out/gtklock/lib
    mv ./libgtklock-dpms.so $out/gtklock/lib/dpms-module.so
  '';
  #  postInstall = ''
  #   mv $out/lib/gtklock/gtklock-dpms.so $out/lib/gtklock/dpms-module.so
  # '';

  meta = {
    description = "Gtklock module which blanks monitors after idle.";
    homepage = "https://git.sr.ht/~aperezdc/gtklock-dpms-module/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
