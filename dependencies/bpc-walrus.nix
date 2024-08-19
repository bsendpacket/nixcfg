{
  lib,
  python312Packages,
  fetchPypi,
  setuptools,
  wheel,
}:

python312Packages.buildPythonApplication rec {
  pname = "bpc-walrus";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xcHTYY9HwtMQzYsi2YQSAQbiNWVqKLpaH4oEWktetA0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = with python312Packages; [
    (callPackage ./bpc-f2format.nix {}) 
    (callPackage ./bpc-utils.nix {})
    (callPackage ./tbtrim.nix {})
    (callPackage ./parso-0_6_0.nix {})
    typing
    typing-extensions
  ];

  optional-dependencies = with python312Packages; {
    docs = [
      sphinx
      sphinx-autodoc-typehints
      sphinxemoji
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
  #   "bpc_walrus"
  # ];

  meta = {
    description = "Backport compiler for Python 3.8 assignment expressions";
    homepage = "https://pypi.org/project/bpc-walrus/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
