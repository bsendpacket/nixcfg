{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "lznt1";
  version = "0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/cWbV9RiADA41XKxfhZao8j5GjPfaJSKNElpoolrwuo=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "lznt1" ];

  meta = with lib; {
    description = "Python module for LZNT1 compression/decompression";
    homepage = "https://pypi.org/project/lznt1/";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = [ ];
  };
}
