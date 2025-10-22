{ pkgs, lib, stdenv, buildPythonPackage, fetchFromGitHub, cmake, python, setuptools, distutils }:

let
  unicorn-emu = stdenv.mkDerivation rec {
    pname = "unicorn";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "unicorn-engine";
      repo = "unicorn";
      rev = version;
      sha256 = "0jgnyaq6ykpbg5hrwc0p3pargmr9hpzqfsj6ymp4k07pxnqal76j";
    };

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DUNICORN_BUILD_SHARED=ON"
    ];

    postInstall = ''
      mkdir -p $out/lib/pkgconfig
      cp unicorn.pc $out/lib/pkgconfig/
    '';

    meta = with lib; {
      description = "Lightweight multi-platform CPU emulator library";
      homepage = "http://www.unicorn-engine.org";
      license = licenses.gpl2Only;
      platforms = platforms.unix;
    };
  };
in
buildPythonPackage rec {
  pname = "unicorn";
  version = unicorn-emu.version;

  src = unicorn-emu.src;
  sourceRoot = "source/bindings/python";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ unicorn-emu ];

  propagatedBuildInputs = [ setuptools distutils ];

  preBuild = ''
    export UNICORN_QEMU_FLAGS="--python"
    export LIBUNICORN_PATH=$out/${python.sitePackages}/unicorn/
    export UNICORN_INCLUDE_PATH=${unicorn-emu}/include
  '';

  postInstall = ''
    # Ensure the Unicorn shared library is in the same directory as the Python module
    mkdir $out/${python.sitePackages}/unicorn/lib
    cp ${unicorn-emu}/lib/libunicorn${stdenv.hostPlatform.extensions.sharedLibrary}.1 $out/${python.sitePackages}/unicorn/lib/libunicorn${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  # Prevent setuptools from trying to fetch dependencies
  SETUPTOOLS_USE_DISTUTILS = "stdlib";

  # Set LD_LIBRARY_PATH for the check phase
  preCheck = ''
    export LD_LIBRARY_PATH=${unicorn-emu}/lib:$LD_LIBRARY_PATH
  '';

  doCheck = true;

  meta = with lib; {
    description = "Python bindings for Unicorn CPU emulator engine";
    homepage = "https://www.unicorn-engine.org/";
    license = [ licenses.gpl2 ];
    maintainers = with maintainers; [ bennofs ris bsendpacket ];
  };
}
