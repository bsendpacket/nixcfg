{
  lib,
  buildPythonApplication,
  fetchPypi,
  setuptools,
  aenum,
  callPackage,
  beautifulsoup4,
  chardet,
  emoji,
  dpkt,
  pathlib2,
  pyshark,
  typing-extensions,
  scapy,
}:

buildPythonApplication rec {
  pname = "pypcapkit";
  version = "1.3.1.post21";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JEjc2Ffv+eWxg/F1XhFRWotNlYQKNZYOZsPWhuhBV0M=";
  };

  build-system = [
    (callPackage ./bpc-f2format.nix {}) 
    (callPackage ./bpc-poseur.nix {}) 
    (callPackage ./bpc-walrus.nix {}) 
    setuptools
  ];

  dependencies = [
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
