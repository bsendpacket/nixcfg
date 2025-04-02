{ lib, stdenv, fetchFromGitHub, cmake, ninja, llvmPackages_14 }:

stdenv.mkDerivation rec {
  pname = "obfuscator-llvm-plugin";
  version = "unstable-2024-07-05";

  src = fetchFromGitHub {
    owner = "eshard";
    repo = "obfuscator-llvm";
    rev = "a629c1f9ee54a2dc99797dcb71f5a92a8478563f";
    sha256 = "sha256-dBCvrDKhek42ca4b6XzOnXsgY8BoQs/sDzTn8Ex3Vw0=";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = with llvmPackages_14; [
    llvm
    clang
  ];

  cmakeFlags = [
    "-DLLVM_DIR=${llvmPackages_14.llvm.dev}/lib/cmake/llvm"
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp libLLVMObfuscator.so $out/lib/
  '';

  meta = with lib; {
    description = "LLVM pass plugin for control-flow flattening and other obfuscations";
    homepage = "https://github.com/eshard/obfuscator-llvm";
    license = licenses.ncsa;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
