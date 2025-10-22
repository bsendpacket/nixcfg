{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "tbtrim";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tihawC6ae3j6uX3mVmj+Le8PXYeDsODfy0t8CmNbPRE=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "tbtrim"
  ];

  meta = {
    description = "A utility to trim Python traceback information";
    homepage = "https://pypi.org/project/tbtrim/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
