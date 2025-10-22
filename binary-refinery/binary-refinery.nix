{ 
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  python-magic,
  distutils,
  pyperclip,
  colorama,
  defusedxml,
  msgpack,
  pefile,
  lief,
  pycryptodomex,
  pyelftools,
  toml,
  oletools,
  lnkparse3,
  jsbeautifier,
  pillow,
  angr,
  unicorn,
  intervaltree,
  capstone
}:

buildPythonPackage rec {
  pname = "binary-refinery";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "binref";
    repo = "refinery";
    rev = "${version}";
    hash = "sha256-0sg/6yZxoujGJsJruqB2+o0319cCQdEHHrlnPT/tBno=";
  };

  pyproject = true;
  build-system = [ setuptools ];
  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    (callPackage ../dependencies/macholib.nix {})
    (callPackage ../dependencies/ktool.nix {})
    (callPackage ../dependencies/cabarchive.nix {})
    (callPackage ../dependencies/pyonenote.nix {})
    (callPackage ../dependencies/pyzstd.nix {})
    (callPackage ../dependencies/pypcapkit.nix {})

    # (callPackage ../speakeasy/speakeasy_refined.nix {})

    python-magic
    distutils
    pyperclip
    colorama
    defusedxml
    msgpack
    pefile
    lief
    pycryptodomex
    pyelftools
    setuptools
    toml
    oletools
    lnkparse3
    jsbeautifier
    pillow
    angr
    # unicorn
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
