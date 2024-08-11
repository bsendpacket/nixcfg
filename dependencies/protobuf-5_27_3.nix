{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "protobuf";
  version = "5.27.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gkYJA+ZA8rfjTugalH/arYneeW0yS8vDj/VDC83q2Cw=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Protocol Buffers are language-neutral, platform-neutral extensible mechanisms for serializing structured data.";
    homepage = "https://protobuf.dev/";
    license = licenses.bsd3;
    maintainers = [ "bsendpacket" ];
  };
}
