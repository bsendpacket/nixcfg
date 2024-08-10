{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "redress";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "goretk";
    repo = "redress";
    rev = "v${version}";
    hash = "sha256-oEYe/BGm+jSzA1iorvTHhsiOFrL1g2gkqYw3ZSO87y8=";
  };

  vendorHash = "sha256-Y9lo4kEVM6VgHbZWQWqbHnyrwW85+FWt489iqNRaHw8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Redress - A tool for analyzing stripped Go binaries";
    homepage = "https://github.com/goretk/redress";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "redress";
  };
}
