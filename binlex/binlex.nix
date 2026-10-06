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
, fetchFromGitHub
, fetchurl
, runCommand
}:

let
  llvm = llvmPackages_22.libllvm;

  liefPrecompiled = fetchzip {
    url = "https://github.com/lief-project/LIEF/releases/download/0.15.1/LIEF-rs-x86_64-unknown-linux-gnu.zip";
    hash = "sha256-jfLPATDharwS0DUpMe+rSvgslqoEi3I/BfGKJcGJsMU=";
    stripRoot = false;
  };

  # The project gitignores vendor/llvm-sys and generates it via `cargo xtask`.
  # It downloads llvm-sys 221.0.1 from crates.io, then patches build.rs and
  # src/lib.rs with templates from xtask/templates/. We replicate that here.
  llvmSysCrate = fetchurl {
    url = "https://static.crates.io/crates/llvm-sys/llvm-sys-221.0.1.crate";
    hash = "sha256-KrzDSjsZDwPCphtVXyGPUpWJ/xNle90v+Kw+hfKr5rs=";
  };

  rawSrc = fetchFromGitHub {
    owner = "c3rb3ru5d3d53c";
    repo = "binlex";
    rev = "f02f270c378b652dcfaca8a88f7d65bd4a95347b";
    hash = "sha256-aldhw3bJ0h9ZqCq0iG27Cv7njtRbMSA6SpAwoyGkaLU=";
  };

  # Prepare a complete source tree so the vendor-staging derivation can find
  # Cargo.lock and the patched vendor/llvm-sys.
  src = runCommand "binlex-source" {} ''
    cp -r ${rawSrc} $out
    chmod -R u+w $out

    cp ${./Cargo.lock} $out/Cargo.lock

    mkdir -p $out/vendor/llvm-sys
    tar xzf ${llvmSysCrate} --strip-components=1 -C $out/vendor/llvm-sys
    cp $out/xtask/templates/llvm-sys-build.rs $out/vendor/llvm-sys/build.rs
    cp $out/xtask/templates/llvm-sys-lib.rs $out/vendor/llvm-sys/src/lib.rs
  '';
in
rustPlatform.buildRustPackage {
  pname = "binlex";
  version = "2.0.0";

  inherit src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-KZg8YcIbSOi3L4kp86bHFDKm00xq3ULLWFy8ODKHsqo=";

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
