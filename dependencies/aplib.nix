{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "aplib";
  version = "0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qh6hpLKp0POGSs8fl5NxUqXNImwHlW9tdjua7pZTxRg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "aplib" ];

  meta = with lib; {
    description = "Module for decompressing aPLib compressed data";
    homepage = "https://pypi.org/project/aplib/";
    license = licenses.gpl3Only;
  };
}
