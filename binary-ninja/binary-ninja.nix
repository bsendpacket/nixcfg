{ pkgs ? import <nixpkgs> {}, binaryNinjaUrl ? null, binaryNinjaHash ? null, pythonEnv }:

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

  binaryNinja = pkgs.stdenv.mkDerivation rec {
    pname = "binary-ninja";
    version = "dev";
    name = "${pname}-${version}";

    src = binaryNinjaZip;

    nativeBuildInputs = with pkgs; [
      unzip
      autoPatchelfHook
      makeWrapper
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
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
      
      # Not sure if this actually works on Wayland currently
      wayland 
      qt6.qtbase
      qt6.qtsvg
      qt6.qtshadertools
      qt6.qtdeclarative
      qt6.qtwayland
      stdenv.cc.cc.lib
      pythonEnv
    ];

    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      mkdir -p $out/opt/binaryninja $out/bin
      cp -r * $out/opt/binaryninja/

      # Create a wrapper script
      cat > $out/bin/binaryninja <<EOF
      #!/bin/sh
      export BN_USER_DIRECTORY="\$HOME/.binaryninja"
      mkdir -p "\$BN_USER_DIRECTORY"
      export QT_QPA_PLATFORM=xcb
      export QT_PLUGIN_PATH="$out/opt/binaryninja/qt"
      export LD_LIBRARY_PATH="$out/opt/binaryninja/binaryninja:${pkgs.lib.makeLibraryPath buildInputs}:\$LD_LIBRARY_PATH"
      export PYTHONPATH="${pythonEnv}/${pythonEnv.sitePackages}:\$PYTHONPATH"
      export PYTHONHOME="${pythonEnv}"
      export BN_INSTALL_DIR="$out/opt/binaryninja"
      exec "$out/opt/binaryninja/binaryninja/binaryninja" "\$@"
      EOF
      chmod +x $out/bin/binaryninja
    '';

    preFixup = ''
      addAutoPatchelfSearchPath $out/opt/binaryninja/binaryninja
    '';

    autoPatchelfIgnoreMissingDeps = [
      "libQt6ShaderTools.so.6"
      "libQt6Qml.so.6"
      "libQt6PrintSupport.so.6"
    ];

    meta = with pkgs.lib; {
      description = "Binary Ninja - A reverse engineering platform";
      homepage = "https://binary.ninja/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
binaryNinja
