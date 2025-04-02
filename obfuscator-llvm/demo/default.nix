{ pkgs ? import <nixpkgs> {} }:

let 
  obfPlugin = pkgs.callPackage ../obfuscator-llvm.nix {};
in
  pkgs.stdenv.mkDerivation {
    pname = "obfuscated-test";
    version = "1.0";

    src = ./demo.c;
    dontUnpack = true;

    nativeBuildInputs = [
      pkgs.llvmPackages_14.clang
      pkgs.llvmPackages_14.llvm
    ];

    buildPhase = ''
      cp $src test.c

      echo "[1/5] Building unobfuscated binary..."
      ${pkgs.llvmPackages_14.clang}/bin/clang -fno-stack-protector -O1 test.c -o unobfuscated

      echo "[2/5] Compiling to LLVM IR..."
      ${pkgs.llvmPackages_14.clang}/bin/clang -fno-stack-protector -S -emit-llvm -O1 test.c -o test.ll

      echo "[3/5] Obfuscating..."
      #export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="flattening"
      #export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="substitution"
      #export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="bogus"
      #export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="split-basic-blocks"
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="flattening,bogus,substitution,split-basic-blocks"

      #export LLVM_OBF_PIPELINESTART_PASSES="substitution"

      export LLVM_OBF_SEED="0xDEADBEEFCAFEBABEDEADBEEFCAFEBABE"
      export LLVM_OBF_DEBUG_SEED="y"

      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_obf.ll

      echo "[4/5] Compiling obfuscated binary..."
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_obf.ll -o test_obf.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_obf.s -o obfuscated
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp unobfuscated obfuscated $out/bin/
    '';

    meta = with pkgs.lib; {
      description = "Demo for obfuscator-llvm (Unobfuscated/Obfuscated)";
      platforms = platforms.linux;
      license = licenses.mit;
    };
  }
