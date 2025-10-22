{ buildPythonPackage, fetchFromGitHub, setuptools }:

buildPythonPackage {
  pname = "chaskey-lts";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "volexity";
    repo = "chaskey-lts";
    rev = "66d75bfa1d32fdac9508e710a9ade234690463bb";
    hash = "sha256-KFMpHSc21V1divx8vUGjHzmoz9ZFcyBgVnK6pmtz7OM=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  nativeBuildInputs = [
    setuptools
  ];

  meta = {
    description = "A pure Python chaskey cipher implementation developed initially for use with the donut_decryptor.";
    homepage = "https://github.com/volexity/chaskey-lts";
    maintainers = [ "bsendpacket" ];
  };
}
