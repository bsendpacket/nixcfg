{ pkgs ? import <nixpkgs> {}, binaryNinjaUrl ? null, binaryNinjaHash ? null, }:

let
  # Since Binary Ninja download URLs are provided via email, please create a file
  # binary-ninja-url.nix, and provide it with the following
  # {
  #   binaryNinjaUrl = "URL of the installer from the email";
  #   binaryNinjaHash = "Leave this empty, let it download, fail, and paste the correct hash";
  # }
  binaryNinjaZip = pkgs.fetchurl {
    url = if builtins.isNull binaryNinjaUrl
      then throw "Binary Ninja URL must be provided"
      else binaryNinjaUrl;
    sha256 = if builtins.isNull binaryNinjaHash
      then throw "Binary Ninja hash must be provided"
      else binaryNinjaHash;
  };

  binaryNinjaAPI = pkgs.python312Packages.buildPythonPackage rec {
    pname = "binary-ninja-api";
    version = "dev";
    name = "${pname}-${version}";
    format = "other";

    src = binaryNinjaZip;

    nativeBuildInputs = [
      pkgs.unzip
      pkgs.autoPatchelfHook
      pkgs.patchelf
    ];

    buildInputs = [
      pkgs.stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      unzip $src -d $TMPDIR
    '';

    # no-op build phase, since there is no setup.py
    buildPhase = ''
      true
    '';

    installPhase = ''
      mkdir -p $out/lib/python3.12/site-packages/binaryninja
      cp -r $TMPDIR/binaryninja/python/binaryninja/* $out/lib/python3.12/site-packages/binaryninja/
      cp $TMPDIR/binaryninja/libbinaryninjacore.so.1 $out/lib/python3.12/

      # Allow libbinaryninjacore.so to find libstdc++.so.6
      patchelf --set-rpath ${pkgs.stdenv.cc.cc.lib}/lib $out/lib/python3.12/libbinaryninjacore.so.1
    '';

    meta = with pkgs.lib; {
      description = "Binary Ninja Python API";
      homepage = "https://binary.ninja/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
  binaryNinjaAPI
