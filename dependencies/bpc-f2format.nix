{
  lib,
  buildPythonApplication,
  fetchPypi,
  callPackage,
  setuptools,
  wheel,
  typing-extensions
}:

buildPythonApplication rec {
  pname = "bpc-f2format";
  version = "0.8.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XCr/32SbnGNwkUb/9CrUSl9rCpXmw2yQdA03MDO1ERw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    (callPackage ./bpc-utils.nix {})
    (callPackage ./tbtrim.nix {})
    (callPackage ./parso-0_6_0.nix {})
    typing-extensions
  ];

  # pythonImportsCheck = [
  #   "bpc_f2format"
  # ];

  meta = {
    description = "Back-port compiler for Python 3.6 formatted string (f-string) literals";
    homepage = "https://pypi.org/project/bpc-f2format/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
