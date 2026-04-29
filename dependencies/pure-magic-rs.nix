{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
}:

buildPythonPackage rec {
  pname = "pure-magic-rs";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qjerome";
    repo = "magic-rs";
    rev = "1a861550bc7a";
    hash = "sha256-Hkk5t9FdAMS4IupxEeYZVJgYWVR+EiW89im5u69+AWs=";
  };

  # Build only the python crate within the workspace
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-8DXpVuOW+K4+uionEx30NVWUl8M8HHYFQoES+aPaLNk=";
  };

  sourceRoot = "${src.name}";
  buildAndTestSubdir = "python";

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "pure_magic_rs" ];

  meta = with lib; {
    description = "Python bindings for pure-magic crate, a pure Rust re-implementation of libmagic";
    homepage = "https://github.com/qjerome/magic-rs/tree/main/python";
    license = with licenses; [ gpl3Only bsd2 ];
  };
}
