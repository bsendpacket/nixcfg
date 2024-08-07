{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyaes";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AsGxQFw408NwsIX7lS3YvqP63O5kEa2Z8xLMEpxTbY8=";
  };

  meta = with lib; {
    description = "A pure-Python implementation of the AES (FIPS-197) block-cipher algorithm and common modes of operation (CBC, CFB, CTR, ECB, OFB) with no dependencies beyond standard Python libraries";
    homepage = "https://github.com/ricmoo/pyaes";
    license = licenses.mit;
    maintainers = [ "bsendpacket" ];
  };
}
