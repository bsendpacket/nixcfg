{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cmake,
  capstone,
  boost,
  z3,
  bitwuzla,
  libxml2,
  libffi,
  llvmPackages_16,
  python
}:

buildPythonPackage {
  pname = "triton";
  version = "unstable-2025-10-15";
  format = "other";

  src = fetchFromGitHub {
    owner = "jonathansalwan";
    repo = "Triton";
    rev = "8b4362604bc1d153eb937f0d5a826005be2f04fe";
    hash = "sha256-+VMgxrNlvUGBsmJBvP5iuITdD9TKGBdgy73NrYi4xeU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    capstone
    boost
    z3
    bitwuzla
    libxml2
    libffi
    llvmPackages_16.llvm
  ];

  cmakeFlags = [
    "-DPYTHON_BINDINGS=ON"
    "-DPYTHON_BINDINGS_AUTOCOMPLETE=ON"
    "-DLLVM_INTERFACE=ON"
    "-DBITWUZLA_INTERFACE=ON"
    "-DCMAKE_PREFIX_PATH=${llvmPackages_16.llvm}"
    "-DPYTHON_EXECUTABLE=${python.interpreter}"
    "-DBITWUZLA_INCLUDE_DIR=${bitwuzla}/include"
    "-DBITWUZLA_LIBRARY=${bitwuzla}/lib/libbitwuzla.so"
  ];

  buildPhase = ''
    cmake --build . --target python-triton -- -j $NIX_BUILD_CORES
    cmake --build . --target python_autocomplete -- -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    cp -r $src/src/libtriton/bindings/python/* $out/${python.sitePackages}/
    cp ./doc/triton_autocomplete/triton.pyi $out/${python.sitePackages}/
    cp ./src/libtriton/libtriton.so $out/${python.sitePackages}/triton.so
  '';

  meta = with lib; {
    description = "Dynamic symbolic execution and binary analysis framework (Python bindings)";
    homepage = "https://github.com/JonathanSalwan/Triton";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
