{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.16.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7VDAgjOHjBVcc6smIuEVzZ5GwPHC4t3Xby58okkz8ZU=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pyzstd"
  ];

  meta = {
    description = "Python bindings to Zstandard (zstd) compression library";
    homepage = "https://pypi.org/project/pyzstd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sendpacket ];
  };
}
