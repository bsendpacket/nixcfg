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
      echo "[1/8] Building unobfuscated binaries..."
      ${pkgs.llvmPackages_14.clang}/bin/clang -fno-stack-protector -O1 test.c -o unobfuscated_O1
      ${pkgs.llvmPackages_14.clang}/bin/clang -fno-stack-protector -O0 test.c -o unobfuscated_O0
      
      echo "[2/8] Compiling to LLVM IR..."
      ${pkgs.llvmPackages_14.clang}/bin/clang -fno-stack-protector -S -emit-llvm -O1 test.c -o test.ll
      
      # Use the same seed for reproducible builds across techniques
      export LLVM_OBF_SEED="0xDEADBEEFCAFEBABEDEADBEEFCAFEBABE"
      export LLVM_OBF_DEBUG_SEED="y"

      echo "[3/8] Creating bogus control flow version..."
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="bogus"
      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_bogus.ll
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_bogus.ll -o test_bogus.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_bogus.s -o obfuscated_bogus
      
      echo "[4/8] Creating control flow flattening version..."
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="flattening"
      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_cff.ll
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_cff.ll -o test_cff.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_cff.s -o obfuscated_cff
      
      echo "[5/8] Creating substitution version..."
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="substitution"
      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_sub.ll
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_sub.ll -o test_sub.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_sub.s -o obfuscated_sub
      
      echo "[6/8] Creating split basic blocks version..."
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="split-basic-blocks"
      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_split.ll
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_split.ll -o test_split.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_split.s -o obfuscated_split
      
      echo "[7/8] Creating combined obfuscation version (no CFF)..."
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="bogus,substitution,split-basic-blocks"
      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_combined_no_cff.ll
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_combined_no_cff.ll -o test_combined_no_cff.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_combined_no_cff.s -o obfuscated_combined_no_cff

      echo "[8/8] Creating combined obfuscation version (Full)..."
      export LLVM_OBF_SCALAROPTIMIZERLATE_PASSES="flattening,bogus,substitution,split-basic-blocks"
      ${pkgs.llvmPackages_14.llvm}/bin/opt \
        -load-pass-plugin=${obfPlugin}/lib/libLLVMObfuscator.so \
        -passes="default<O0>" \
        test.ll -o test_combined.ll
      ${pkgs.llvmPackages_14.llvm}/bin/llc test_combined.ll -o test_combined.s
      ${pkgs.llvmPackages_14.clang}/bin/clang test_combined.s -o obfuscated_combined
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp unobfuscated_O0 unobfuscated_O1 \
        obfuscated_bogus obfuscated_cff \
        obfuscated_sub obfuscated_split \
        obfuscated_combined_no_cff obfuscated_combined \
         $out/bin/
         
      # Preserve the intermediate files for analysis
      mkdir -p $out/share/obfuscator-demo
      cp test.ll test_bogus.ll test_cff.ll test_sub.ll test_split.ll test_combined.ll \
         test_bogus.s test_cff.s test_sub.s test_split.s test_combined.s \
         $out/share/obfuscator-demo/
    '';
    meta = with pkgs.lib; {
      description = "Demo for obfuscator-llvm (multiple obfuscation techniques)";
      platforms = platforms.linux;
      license = licenses.mit;
    };
  }
