{ lib
, python312Packages
, fetchFromGitHub
}:

python312Packages.buildPythonPackage {
  pname = "binary-refinery";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "binref";
    repo = "refinery";
    rev = "0.7.6";
    hash = "sha256-8/Ueet+ks1YjjMO4Vc9YzA38NACCy6LUCEg5HDRYekQ=";
  };

  nativeBuildInputs = with python312Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python312Packages; [
    (callPackage ../dependencies/macholib.nix {})
    (callPackage ../dependencies/ktool.nix {})
    (callPackage ../dependencies/cabarchive.nix {})
    (callPackage ../dependencies/pyonenote.nix {})
    (callPackage ../dependencies/pyzstd.nix {})
    (callPackage ../dependencies/pypcapkit.nix {})

    python-magic
    distutils
    pyperclip
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
    intervaltree
    capstone
  ];

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
