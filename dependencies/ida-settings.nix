{ lib, buildPythonPackage, fetchPypi, pip, callPackage, six }:

buildPythonPackage rec {
  pname = "ida-settings";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E3FzC05kvziIRbZaQb6glOveil06Bb307fL0KquoMmI=";
  };

  nativeBuildInputs = [
    pip
  ];

  propagatedBuildInputs = [
    (callPackage ./ida-netcode.nix {})

    six
  ];

  # Disable tests, they do pyQt checking, and I won't be using this dependency anyway
  doCheck = false;

  meta = with lib; {
    description = "ida_settings provides a mechanism for settings and fetching configration values for IDAPython scripts and plugins";
    homepage = "https://github.com/williballenthin/ida-settings";
    license = licenses.asl20;
    maintainers = [ "bsendpacket" ];
  };
}

