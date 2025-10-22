{
  lib,
  buildPythonApplication,
  fetchPypi,
  setuptools,
  wheel,
  callPackage,
  typing,
  typing-extensions,
}:

buildPythonApplication rec {
  pname = "bpc-poseur";
  version = "0.4.3.post1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k45/3xV7j9YJ9VEbEak7ZeSzuoAsY22VV1jloDEFrz4=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    (callPackage ./bpc-f2format.nix {})
    (callPackage ./bpc-utils.nix {})
    (callPackage ./tbtrim.nix {})
    (callPackage ./parso-0_6_0.nix {})
    typing
    typing-extensions
  ];

  # pythonImportsCheck = [
  #   "bpc_poseur"
  # ];

  meta = {
    description = "Back-port compiler for Python 3.8 positional-only parameter syntax";
    homepage = "https://pypi.org/project/bpc-poseur/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bsendpacket ];
  };
}
