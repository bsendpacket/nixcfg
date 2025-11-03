{
  lib, 
  buildPythonPackage,
  setuptools,
  wheel,
  capstone,
  jsonschema,
  pefile,
  pycryptodome,
  fetchFromGitHub,
  callPackage
}:

buildPythonPackage {
  pname = "speakeasy";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "speakeasy";
    rev = "22ef6f7bf5323b2b3ddb10f3c9b6bc150ac78c95";
    hash = "sha256-M0ePCRcRJTKJWKURtvwUo7fLWQzZ6sA6bPkgkh4e+lk=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    (callPackage ../dependencies/lznt1.nix {})
    (callPackage ../dependencies/unicorn-1_0_2.nix {})

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
    maintainers = [ "bsendpacket" ];
    mainProgram = "speakeasy";
  };
}
