{ lib
, rustPlatform
, llvmPackages_22
, valgrind
, cmake
, ninja
, pkg-config
, perl
, python3
, libffi
, libxml2
, openssl
, protobuf
, fetchzip
}:

let
  llvm = llvmPackages_22.libllvm;

  liefPrecompiled = fetchzip {
    url = "https://github.com/lief-project/LIEF/releases/download/0.15.1/LIEF-rs-x86_64-unknown-linux-gnu.zip";
    hash = "sha256-jfLPATDharwS0DUpMe+rSvgslqoEi3I/BfGKJcGJsMU=";
    stripRoot = false;
  };
in
rustPlatform.buildRustPackage {
  pname = "binlex";
  version = "2.0.0";

  src = lib.cleanSourceWith {
    src = ./binlex;
    filter = path: type:
      let baseName = baseNameOf path; in
      baseName != ".git" && baseName != "target" && baseName != "docker" && baseName != "venv";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BtdV+8ME+wVialuliXayfTiP1QgO6uZikE5L5YFwMdM=";

  env = {
    LLVM_SYS_221_PREFIX = "${llvm.dev}";
    VEX_LIBS = "${valgrind}/lib/valgrind";
    LIEF_RUST_PRECOMPILED = "${liefPrecompiled}";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    python3
    protobuf
    rustPlatform.bindgenHook
  ];

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  buildInputs = [
    llvm
    llvm.dev
    valgrind
    libffi
    libxml2
    openssl
  ];

  cargoBuildFlags = [
    "--workspace"
    "--exclude" "binlex-python"
    "--exclude" "binlex-test"
    "--exclude" "binlex-web"
    "--exclude" "binlex-server"
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Binary Genetic Trait Lexer Framework";
    homepage = "https://github.com/c3rb3ru5d3d53c/binlex";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
