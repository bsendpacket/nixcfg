{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = [
    pkgs.llvmPackages_14.clang
    pkgs.llvmPackages_14.llvm
    (pkgs.callPackage ../obfuscator-llvm.nix {})
  ];

  shellHook = ''
    export OBF_PLUGIN_LIB=$(find ${pkgs.callPackage ./obfuscator-llvm.nix {}}/lib -name "libLLVMObfuscator.so")
    echo "Use the plugin with: clang -fno-legacy-pass-manager -fpass-plugin=$OBF_PLUGIN_LIB"
  '';
}
