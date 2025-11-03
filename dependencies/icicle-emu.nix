{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  wheel,
}:

buildPythonPackage rec {
  pname = "icicle-python";
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icicle-emu";
    repo = "icicle-python";
    rev = version;
    hash = "sha256-QQdy/xIV8Vq8xbkd652FQxse6vOO4JcSP7G+8t1VD14=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-3ASE8FKRWPJMlySPm68M8UA0Ea+8++y3OTSjPy2uibQ=";
  };

  RUSTFLAGS = "-A dangerous_implicit_autorefs -A elided_lifetimes_in_paths";

  build-system = [
    cargo
    setuptools
    setuptools-rust
    wheel
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = [
    setuptools
    setuptools-rust
    wheel
  ];

  pythonImportsCheck = [
    "icicle"
  ];

  meta = {
    description = "Python bindings for the Icicle emulator";
    homepage = "https://github.com/icicle-emu/icicle-python";
    license = lib.licenses.boost;
    maintainers = [ ];
  };
}
