{ lib, fetchPypi, buildPythonPackage, altgraph, setuptools }:

buildPythonPackage rec {
  pname = "macholib";
  version = "1.16.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9AjJOrLplc0sRuNP4yixMEBL4UNGnkG8NmyAdEiXk2I=";
  };

  pyproject = true;
  build-system = [ setuptools ];
  # Disable tests, as they only work on macOS
  doCheck = false;

  propagatedBuildInputs = [
    altgraph
  ];

  meta = with lib; {
    description = "Mach-O header analysis and editing";
    homepage = "https://github.com/ronaldoussoren/macholib";
    license = licenses.mit;
    maintainers = [ ];
  };
}
