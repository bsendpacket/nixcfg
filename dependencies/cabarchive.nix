{ lib, python312Packages, fetchPypi }:

python312Packages.buildPythonPackage rec {
  pname = "cabarchive";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BPYAiUcxFM8m6rK34dCWEcW/r47dMgLazvZrtcceSM8=";
  };

  # Disable tests, as they require additional files
  doCheck = false;

  meta = with lib; {
    description = "A pure-python library for creating and extracting cab files";
    homepage = "https://github.com/hughsie/python-cabarchive";
    license = licenses.lgpl21Only;
    maintainers = [ "bsendpacket" ];
  };
}
