{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  setuptools,
  wheel,
  typing,
  typing-extensions
}:

buildPythonPackage rec {
  pname = "bpc-utils";
  version = "0.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CVQoLpR+cSFStjlvewRIfCjizf735FOEU8sTZi+qfTM=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    (callPackage ./parso-0_6_0.nix {}) 
    typing
    typing-extensions
  ];

  meta = {
    description = "Utility library for the Python bpc compiler";
    homepage = "https://pypi.org/project/bpc-utils/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
