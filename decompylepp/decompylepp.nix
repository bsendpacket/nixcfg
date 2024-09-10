{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation {
  pname = "decompyle-plus-plus";
  version = "unstable-2024-08-12";

  src = fetchFromGitHub {
    owner = "zrax";
    repo = "pycdc";
    rev = "dc6ca4ae36128f2674b5b4c9b0ce6fdda97d4df0";
    hash = "sha256-KoT8IL86oa4WkFuPQT1N/Nc3WJlSX3AyuAKw1esjv8s=";
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
    maintainers = with maintainers; [ bsendpacket ];
  };
}
