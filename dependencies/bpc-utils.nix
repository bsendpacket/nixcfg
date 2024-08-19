{
  lib,
  python312Packages,
  fetchPypi,
}:

python312Packages.buildPythonPackage rec {
  pname = "bpc-utils";
  version = "0.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CVQoLpR+cSFStjlvewRIfCjizf735FOEU8sTZi+qfTM=";
  };

  build-system = with python312Packages; [
    setuptools
    wheel
  ];

  dependencies = with python312Packages; [
    (callPackage ./parso-0_6_0.nix {}) 
    typing
    typing-extensions
  ];

  optional-dependencies = with python312Packages; {
    docs = [
      sphinx
      sphinx-autodoc-typehints
    ];
    lint = [
      bandit
      colorlabels
      flake8
      mypy
      (callPackage ./parso-0_6_0.nix {}) 
      pylint
      vermin
    ];
    test = [
      coverage
      pytest
      pytest-doctestplus
    ];
  };

  # pythonImportsCheck = [
  #   "bpc_utils"
  # ];

  meta = {
    description = "Utility library for the Python bpc compiler";
    homepage = "https://pypi.org/project/bpc-utils/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
