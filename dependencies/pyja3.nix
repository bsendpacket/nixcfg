{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  dpkt
}:

buildPythonPackage rec {
  pname = "pyja3";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zReC3A9r5fZlxKcrVNDvjpuP1MnvMBp4ORHfbw8r6J8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    dpkt
  ];

  pythonImportsCheck = [
    "ja3"
  ];

  meta = {
    description = "Generate JA3 fingerprints from PCAPs using Python";
    homepage = "https://pypi.org/project/pyja3/";
    license = lib.licenses.bsd2;
    mainProgram = "ja3";
  };
}
