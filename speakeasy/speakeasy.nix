{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "speakeasy";
  version = "1.5.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "speakeasy";
    rev = "v${version}";
    hash = "sha256-PhIIk0UNNPZQAhP/149EEAi5ECOOShmXJGHyGeIQUqk=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    (callPackage ../donut-decryptor/dependencies/lznt1.nix {})
    (callPackage ./dependencies/unicorn.nix {})

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
