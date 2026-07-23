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
  capstone,
  xdis,
  javaobj-py3,
  py7zr,
  pyzstd,
  cython,
}:

buildPythonPackage rec {
  pname = "binary-refinery";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "binref";
    repo = "refinery";
    rev = "${version}";
    hash = "sha256-dJU26PpPKfVh2CPjmBxkfAgP9+VnXFzrpygg3cvylLw=";
  };

  pyproject = true;
  build-system = [ setuptools ];
  nativeBuildInputs = [
    setuptools
    wheel
    cython
  ];

  propagatedBuildInputs = [
    (callPackage ../dependencies/macholib.nix {})
    (callPackage ../dependencies/ktool.nix {})
    (callPackage ../dependencies/cabarchive.nix {})
    (callPackage ../dependencies/pyonenote.nix {})
    (callPackage ../dependencies/pypcapkit.nix {})
    (callPackage ../dependencies/icicle-emu.nix {})
    (callPackage ../dependencies/pure-magic-rs.nix {})

    (callPackage ../speakeasy/speakeasy_refined.nix {})
    # (callPackage ../speakeasy/speakeasy.nix {})

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
    unicorn
    intervaltree
    capstone
    xdis
    javaobj-py3
    py7zr
    pyzstd
  ];

  # Disable tests for now
  doCheck = false;

  # Prevent setuptools from trying to fetch dependencies
  SETUPTOOLS_USE_DISTUTILS = "stdlib";

  meta = with lib; {
    description = "Binary Refinery™ is a Python-based toolset for transforming binary data, designed for malware triage, and allows for the creation of complex pipelines from simple, stdin-to-stdout scripts similar to CyberChef but for the command line.";
    homepage = "https://github.com/binref/refinery/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
