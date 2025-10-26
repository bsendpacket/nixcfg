{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  typing-extensions
}:

buildPythonPackage rec {
  pname = "dictdumper";
  version = "0.8.4.post3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a0OnIFZPfd9PodLTtddNrNNytbTXWAiWJu161nTqL9Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "dictdumper"
  ];

  meta = {
    description = "DictDumper: comprehensive network packet analysis library";
    homepage = "https://pypi.org/project/dictdumper/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
