{ lib, python312Packages, fetchPypi }:

python312Packages.buildPythonPackage rec {
  pname = "kimg4";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zsQelFk7Bwy+4QeqANLXIH8zXFxfjVGrmitcL9P4kyo=";
  };

  doCheck = false;

  meta = {
    description = "pure-python library for parsing/decrypting Apple's proprietary IMG4 format";
    homepage = "https://github.com/0cyn/kimg4";
    maintainers = [ "bsendpacket" ];
  };
}
