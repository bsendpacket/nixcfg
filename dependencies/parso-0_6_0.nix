{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WX823lECqNsF/99+zcdhg4uGVlpKERYExueL6u3xsEU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "parso"
  ];

  meta = {
    description = "A Python Parser";
    homepage = "https://pypi.org/project/parso/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
