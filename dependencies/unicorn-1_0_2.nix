{ lib
, python312Packages
, fetchPypi
, setuptools
, wheel
}:

python312Packages.buildPythonPackage rec {
  pname = "unicorn";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/S1SJdOUxUr4ibVQuGszroMRlF0iJXRFCUNM2GZjqUo=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python312Packages; [
    distutils
  ];

  pythonImportsCheck = [ "unicorn" ];

  meta = with lib; {
    description = "Unicorn CPU emulator engine";
    homepage = "https://pypi.org/project/unicorn/1.0.2/";
    license = licenses.gpl2;
    maintainers = [ "bsendpacket" ];
  };
}
