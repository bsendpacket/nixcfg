{ lib, python312Packages, fetchFromGitHub }:

python312Packages.buildPythonPackage rec {
  pname = "speakeasy";
  version = "1.5.11";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "speakeasy";
    rev = "v${version}";
    hash = "sha256-PhIIk0UNNPZQAhP/149EEAi5ECOOShmXJGHyGeIQUqk=";
  };

  buildInputs = with python312Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python312Packages; [
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