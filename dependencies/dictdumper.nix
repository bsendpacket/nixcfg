{
  lib,
  python312Packages,
  fetchPypi,
  setuptools,
}:

python312Packages.buildPythonPackage rec {
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

  dependencies = with python312Packages; [
    typing-extensions
  ];

  optional-dependencies = with python312Packages; {
    docs = [
      furo
      sphinx
      sphinx-autodoc-typehints
      sphinx-copybutton
      sphinx-opengraph
    ];
  };

  pythonImportsCheck = [
    "dictdumper"
  ];

  meta = {
    description = "DictDumper: comprehensive network packet analysis library";
    homepage = "https://pypi.org/project/dictdumper/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
