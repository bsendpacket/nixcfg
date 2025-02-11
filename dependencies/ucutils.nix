{
  lib,
  python312Packages,
  fetchFromGitHub,
}:

python312Packages.buildPythonPackage rec {
  pname = "ucutils";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "ucutils";
    rev = "v${version}";
    hash = "sha256-zu3HKkns5tFMhz6ba+yf8dsv3SQpq9FEhmOWeCOG4oM=";
  };

  build-system = with python312Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python312Packages; [
    capstone
    hexdump
    pefile
    setuptools
    unicorn
  ];

  optional-dependencies = with python312Packages; {
    build = [
      build
      setuptools
    ];
    dev = [
      black
      isort
      mypy
      pycodestyle
      pytest
      pytest-instafail
      pytest-sugar
      types-setuptools
    ];
  };

  pythonImportsCheck = [
    "ucutils"
  ];

  meta = {
    description = "Convenience routines for working with the Unicorn emulator in Python";
    homepage = "https://github.com/williballenthin/ucutils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
