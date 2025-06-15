{ lib, fetchFromGitHub, rustPlatform, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "i3wsr";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "roosta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CdtAIwwSKE312o2PdJyCr1numRad1vu1lt1uf5TDr7k=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "i3ipc-0.10.1" = "sha256-E0k5tpltTw4+Oea+47qXMtYfwpK1PEuuYEP7amjB7Ic=";
    };
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libxcb ];

  # has not tests
  doCheck = false;

  meta = with lib; {
    mainProgram = "i3wsr";
    description = "Automatically change i3 workspace names based on their contents";
    longDescription = ''
      Automatically sets the workspace names to match the windows on the workspace.
      The chosen name for a workspace is a user-defined composite of the WM_CLASS X11
      window property for each window in a workspace.
    '';
    homepage = "https://github.com/roosta/i3wsr";
    license = licenses.mit;
    maintainers = [ maintainers.sebbadk ];
  };
}
