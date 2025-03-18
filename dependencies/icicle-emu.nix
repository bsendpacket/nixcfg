{
  lib,
  python312Packages,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

python312Packages.buildPythonPackage rec {
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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-NlGVqYVV4zXuS8r6OBKH5f6oUm3BWvq2pN8I91dkEEo=";
  };

  build-system = with python312Packages; [
    cargo
    setuptools
    setuptools-rust
    wheel
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = with python312Packages; [
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
    maintainers = with lib.maintainers; [ ];
  };
}
