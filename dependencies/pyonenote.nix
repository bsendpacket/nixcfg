{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "pyOneNote";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1XaklqXg01LvPQB/f6KgQkBJri78PiHTA7DRQ07XKOE=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "pyOneNote is a lightweight python library to read OneNote files. The main goal of this parser is to allow cybersecurity analyst to extract useful information, such as embedded files, from OneNote files.";
    homepage = "https://github.com/DissectMalware/pyOneNote";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
