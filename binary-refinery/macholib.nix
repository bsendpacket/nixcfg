{ lib, buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "macholib";
  version = "1.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B66eFejkzZp4gBPYH1kIs2Cap2+bFCG66cTXYG7IajA=";
  };

  # Disable tests, as they only work on macOS
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    altgraph
  ];

  meta = with lib; {
    description = "Mach-O header analysis and editing";
    homepage = "https://github.com/ronaldoussoren/macholib";
    license = licenses.mit;
    maintainers = [ "bsendpacket" ];
  };
}
