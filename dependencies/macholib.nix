{ lib, fetchPypi, buildPythonPackage, altgraph, setuptools }:

buildPythonPackage rec {
  pname = "macholib";
  version = "1.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B66eFejkzZp4gBPYH1kIs2Cap2+bFCG66cTXYG7IajA=";
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
    maintainers = [ "bsendpacket" ];
  };
}
