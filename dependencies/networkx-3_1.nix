{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "networkx";
  version = "3.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3jRjNUCPhN4Orab/n6+v/5vNoR8KDfqpMRM967FGq2E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  disabledTests = [
    "test_connected_raise"
  ];

  meta = with lib; {
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    homepage = "https://networkx.github.io/";
    license = licenses.bsd3;
    maintainers = [ "bsendpacket" ];
  };
}


