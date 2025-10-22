{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  capstone,
  yara-python
}:

buildPythonPackage rec {
  pname = "mk-yara";
  version = "unstable-2019-12-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "mkYARA";
    rev = "8147f91809db815687e55ddcdc88d18538940704";
    hash = "sha256-QIqFXAPEly+oxUntLNAqCbtlrwafUmeon6TVQ76hGTI=";
  };

  propagatedBuildInputs = [
    capstone
    yara-python
  ];

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "mkyara"
  ];

  meta = {
    description = "Generating YARA rules based on binary code";
    homepage = "https://github.com/fox-it/mkYARA";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
