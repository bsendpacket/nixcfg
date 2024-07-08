{ lib
, python3Packages
, fetchFromGitHub
, python-magic
}:

python3Packages.buildPythonApplication {
  pname = "binary-refinery";
  version = "0.6.42";

  src = fetchFromGitHub {
    owner = "binref";
    repo = "refinery";
    rev = "0.6.42";
    sha256 = "sha256-s98ILKtU54ZmGaY2lrzlCTNlXJNXEoZEsDHT9MIqJAY=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    python-magic
  ] ++ (with python3Packages; [
    (callPackage ./dependencies/macholib.nix {})
    (callPackage ./dependencies/cabarchive.nix {})
    (callPackage ./dependencies/pyonenote.nix {})
    colorama
    defusedxml
    msgpack
    pefile
    pycryptodomex
    pyelftools
    setuptools
    toml
    oletools
    lnkparse3
    jsbeautifier
    pillow
    angr
    unicorn
  ]);

  # Disable tests for now
  doCheck = false;

  # Prevent setuptools from trying to fetch dependencies
  SETUPTOOLS_USE_DISTUTILS = "stdlib";

  meta = with lib; {
    description = "Binary Refinery™ is a Python-based toolset for transforming binary data, designed for malware triage, and allows for the creation of complex pipelines from simple, stdin-to-stdout scripts similar to CyberChef but for the command line.";
    homepage = "https://github.com/binref/refinery/";
    license = licenses.bsd3;
    maintainers = [ "bsendpacket" ];
  };
}
