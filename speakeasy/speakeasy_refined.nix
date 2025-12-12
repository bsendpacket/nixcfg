{ 
  lib, 
  buildPythonPackage, 
  callPackage, 
  fetchFromGitHub, 
  setuptools, 
  wheel, 
  unicorn,
  capstone, 
  jsonschema, 
  pefile, 
  pycryptodome 
}:

buildPythonPackage rec {
  pname = "speakeasy";
  version = "1.6.1-br003";

  src = fetchFromGitHub {
    owner = "binref";
    repo = "speakeasy";
    rev = "${version}";
    hash = "sha256-t+u5Up1lJCH3zLhbPS0eMTN8iFzUanFBwLlXduozWE4=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  buildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    (callPackage ../dependencies/lznt1.nix {})

    unicorn
    capstone
    jsonschema
    pefile
    pycryptodome
  ];

  pythonImportsCheck = [ "speakeasy" ];

  meta = with lib; {
    description = "Windows kernel and user mode emulation";
    homepage = "https://github.com/mandiant/speakeasy";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "speakeasy";
  };
}
