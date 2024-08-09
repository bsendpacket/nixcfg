{ lib, buildPythonPackage, python3Packages, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "ida-netcode";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "ida-netnode";
    rev = "1476d505de628282febe4f4d32708c2ba6fdbf0b";
    hash = "sha256-hXApNeeDYHX41zuYDpSNqSXdM/c8DoVXuB6NMqYf7iU=";
  };

  nativeBuildInputs = with python3Packages; [
    pip
  ];

  propagatedBuildInputs = with python3Packages; [
    six
  ];

  # Disable tests, as they require IDA API to be installed
  doCheck = false;

  meta = with lib; {
    description = "Humane API for storing and accessing persistent data in IDA Pro databases";
    homepage = "https://github.com/williballenthin/ida-netcode";
    license = licenses.asl20;
    maintainers = [ "bsendpacket" ];
  };
}

