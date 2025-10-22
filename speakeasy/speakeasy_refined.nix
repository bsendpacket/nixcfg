{ lib, buildPythonPackage, callPackage, fetchFromGitHub, setuptools, wheel, unicorn, capstone, jsonschema, pefile, pycryptodome }:

buildPythonPackage rec {
  pname = "speakeasy";
  version = "1.5.11b0.post1";

  src = fetchFromGitHub {
    owner = "binref";
    repo = "speakeasy";
    rev = "56379d0763b035df2c288451f033732b3fb94b67";
    hash = "sha256-bgUODRW3VlZ4kdysjuu2VgwICw5b+GiQGH46fJPIhUA=";
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
    maintainers = [ "bsendpacket" ];
    mainProgram = "speakeasy";
  };
}
