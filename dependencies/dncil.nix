{ 
  lib, 
  buildPythonPackage, 
  fetchPypi, 
  setuptools
}:

buildPythonPackage rec {
  pname = "dncil";
  version = "1.0.2";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FVdnXC0TUdMmBQmIHP8DgzCfgc2klE7Sw/XMNSlTqhU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "dncil is a Common Intermediate Language (CIL) disassembly library written in Python that supports parsing the header, instructions, and exception handlers of .NET managed methods.";
    homepage = "https://github.com/mandiant/dncil";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

