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

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      glibc
      libglvnd
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilcursor
      xorg.libXrender
      xorg.libXext
      xorg.libXfixes
      xorg.xkeyboardconfig
      libxkbcommon
      fontconfig
      freetype
      libpng
      zlib
      xorg.libXi
      dbus
      wayland 
      qt6.qtbase
      qt6.qtsvg
      qt6.qtshadertools
      qt6.qtdeclarative
      qt6.qtwayland
      stdenv.cc.cc.lib
    ];

    dontWrapQtApps = true;

    # propagatedBuildInputs = [
    #   pkgs.python312Packages.pyside6
    # ];

    unpackPhase = ''
      unzip $src -d $TMPDIR
    '';

    # no-op build phase, since there is no setup.py
    buildPhase = ''
      true
      '';

    preFixup = ''
      # Create a directory for all bundled libraries
      mkdir -p $out/lib/bundled
      # Copy all shared libraries to our bundled directory
      for lib in $TMPDIR/binaryninja/*.so*; do
        if [ -f "$lib" ]; then
          cp "$lib" $out/lib/bundled/
        fi
      done
      
      # Set up autoPatchelf to look in our bundled directory
      export LD_LIBRARY_PATH="$out/lib/bundled:$LD_LIBRARY_PATH"
    '';
    
    installPhase = ''
      mkdir -p $out/lib/python3.12/site-packages/binaryninja
      mkdir -p $out/lib/python3.12/site-packages/binaryninjaui
      cp -r $TMPDIR/binaryninja/python/binaryninja/* $out/lib/python3.12/site-packages/binaryninja/
      cp -r $TMPDIR/binaryninja/python/binaryninjaui/* $out/lib/python3.12/site-packages/binaryninjaui/
      cp $TMPDIR/binaryninja/libbinaryninjacore.so.1 $out/lib/python3.12/
      cp $TMPDIR/binaryninja/libbinaryninjaui.so.1 $out/lib/python3.12/

      # Allow libbinaryninjacore.so/libbinaryninjaui.so.1 to find required libraries
      patchelf --set-rpath ${pkgs.stdenv.cc.cc.lib}/lib $out/lib/python3.12/libbinaryninjacore.so.1
      patchelf --set-rpath ${pkgs.stdenv.cc.cc.lib}/lib $out/lib/python3.12/libbinaryninjaui.so.1
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
