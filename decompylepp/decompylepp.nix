{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation {
  pname = "decompyle-plus-plus";
  version = "unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "zrax";
    repo = "pycdc";
    rev = "a05ddec0d889efe3a9082790df4e2ed380d6a555";
    hash = "sha256-VQrTfYrbo3OcKFy5LioTrMRox5/lfmx7ZDpxTLf517A=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp pycdc pycdas $out/bin/
  '';

  meta = with lib; {
    description = "C++ python bytecode disassembler and decompiler";
    homepage = "https://github.com/zrax/pycdc";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
