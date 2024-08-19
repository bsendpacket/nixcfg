{
  lib,
  python312Packages,
  fetchPypi,
  setuptools,
  wheel,
}:

python312Packages.buildPythonPackage rec {
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

  optional-dependencies = with python312Packages; {
    qa = [
      flake8
      mypy
      types-setuptools
    ];
    testing = [
      docopt
      pytest
    ];
  };

  pythonImportsCheck = [
    "parso"
  ];

  meta = {
    description = "A Python Parser";
    homepage = "https://pypi.org/project/parso/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
