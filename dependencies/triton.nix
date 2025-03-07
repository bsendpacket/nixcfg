{
  lib,
  fetchFromGitHub,
  python312Packages,
  cmake,
  capstone,
  boost,
  z3,
  bitwuzla,
  libxml2,
  libffi,
  llvmPackages_14,
}:

python312Packages.buildPythonPackage {
  pname = "triton";
  version = "unstable-2025-02-15";
  format = "other";

  src = fetchFromGitHub {
    owner = "jonathansalwan";
    repo = "Triton";
    rev = "e312eafcdf507d9aebd0f8a7daf2eb4c28a19d30";
    hash = "sha256-f+hgmcyDEtNfVtZ/WdFGrnxi6sdEDD2jNegj8MqTLC8=";
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
    llvmPackages_14.llvm
  ];

  cmakeFlags = [
    "-DPYTHON_BINDINGS=ON"
    "-DPYTHON_BINDINGS_AUTOCOMPLETE=ON"
    "-DLLVM_INTERFACE=ON"
    "-DBITWUZLA_INTERFACE=ON"
    "-DCMAKE_PREFIX_PATH=${llvmPackages_14.llvm}"
    "-DPYTHON_EXECUTABLE=${python312Packages.python.interpreter}"
    "-DBITWUZLA_INCLUDE_DIR=${bitwuzla}/include"
    "-DBITWUZLA_LIBRARY=${bitwuzla}/lib/libbitwuzla.so"
  ];

  buildPhase = ''
    cmake --build . --target python-triton -- -j $NIX_BUILD_CORES
    cmake --build . --target python_autocomplete -- -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/${python312Packages.python.sitePackages}
    cp -r $src/src/libtriton/bindings/python/* $out/${python312Packages.python.sitePackages}/
    cp ./doc/triton_autocomplete/triton.pyi $out/${python312Packages.python.sitePackages}/
    cp ./src/libtriton/libtriton.so $out/${python312Packages.python.sitePackages}/triton.so
  '';

  meta = with lib; {
    description = "Dynamic symbolic execution and binary analysis framework (Python bindings)";
    homepage = "https://github.com/JonathanSalwan/Triton";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.linux;
  };
}
