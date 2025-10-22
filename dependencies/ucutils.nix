{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  capstone,
  hexdump,
  pefile,
  unicorn
}:

buildPythonPackage rec {
  pname = "ucutils";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "ucutils";
    rev = "v${version}";
    hash = "sha256-zu3HKkns5tFMhz6ba+yf8dsv3SQpq9FEhmOWeCOG4oM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    capstone
    hexdump
    pefile
    setuptools
    unicorn
  ];

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
