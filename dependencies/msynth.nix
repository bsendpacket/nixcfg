{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  miasm,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "msynth";
  version = "unstable-2025-05-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrphrazer";
    repo = "msynth";
    rev = "d719a58e44703adcb347aae0b3c61a327e041fd7";
    hash = "sha256-KdpfdFvGZ/tMMMwzf6ezlLrIE5uM6rWZTl8HrRvEldY=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    miasm
    wheel
    z3-solver
  ];

  pythonImportsCheck = [
    "msynth"
  ];

  meta = {
    description = "Code deobfuscation framework to simplify Mixed Boolean-Arithmetic (MBA) expressions";
    homepage = "https://github.com/mrphrazer/msynth";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
  };
}
