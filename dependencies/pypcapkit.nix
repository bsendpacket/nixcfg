{
  lib,
  python312Packages,
  fetchPypi,
}:

python312Packages.buildPythonApplication rec {
  pname = "pypcapkit";
  version = "1.3.1.post21";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JEjc2Ffv+eWxg/F1XhFRWotNlYQKNZYOZsPWhuhBV0M=";
  };

  build-system = with python312Packages; [
    (callPackage ./bpc-f2format.nix {}) 
    (callPackage ./bpc-poseur.nix {}) 
    (callPackage ./bpc-walrus.nix {}) 
    setuptools
  ];

  dependencies = with python312Packages; [
    (callPackage ./dictdumper.nix {})
    (callPackage ./tbtrim.nix {})
    aenum
    beautifulsoup4
    chardet
    emoji
    dpkt
    pathlib2
    pyshark
    typing-extensions
    scapy
  ];

  optional-dependencies = with python312Packages; {
    docs = [
      furo
      mypy-extensions
      sphinx
      sphinx-autodoc-typehints
      sphinx-copybutton
      sphinx-opengraph
      typing-extensions
    ];
    vendor = [
      beautifulsoup4
      requests
    ];
  };

  pythonImportsCheck = [
    "pcapkit"
  ];

  meta = {
    description = "PyPCAPKit: comprehensive network packet analysis library";
    homepage = "https://pypi.org/project/pypcapkit/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bsendpacket ];
    mainProgram = "pypcapkit";
  };
}
