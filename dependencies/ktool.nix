{ 
  lib, 
  fetchPypi, 
  poetry-core, 
  setuptools, 
  wheel, 
  buildPythonPackage, 
  pygments, 
  callPackage
}:

buildPythonPackage rec {
  pname = "k2l";
  version = "2.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-66QFjxutsk7aHq4LNB+iE0tzsunhQBksakJ3YvsH11g=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pygments
    (callPackage ./kimg4.nix {})
    (callPackage ./pyaes.nix {})
  ];

  meta = with lib; {
    description = "MachO/ObjC Analysis + Editing toolkit";
    homepage = "https://github.com/0cyn/ktool";
    license = licenses.mit;
    maintainers = [ ];
  };
}
