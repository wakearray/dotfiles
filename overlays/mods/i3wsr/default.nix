{ prev }:
prev.i3wsr.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname;
  version = "3.0.0";

  src = prev.fetchFromGitHub {
    owner = "roosta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CdtAIwwSKE312o2PdJyCr1numRad1vu1lt1uf5TDr7k=";
  };

  cargoHash = "";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "i3ipc-0.10.1" = "sha256-E0k5tpltTw4+Oea+47qXMtYfwpK1PEuuYEP7amjB7Ic=";
    };
  };
})
