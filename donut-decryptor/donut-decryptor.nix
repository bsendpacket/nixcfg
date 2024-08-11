{ python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication {
  pname = "donut-decryptor";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "volexity";
    repo = "donut-decryptor";
    rev = "8832d47364e73d0cf926864f635b6bb42ab060a2";
    hash = "sha256-numLXWOm8fE0MSu0cnzWL4Vqtm0gM/VARtP7rDCtj+Q=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    (callPackage ../dependencies/chaskey-lts.nix {})
    (callPackage ../dependencies/aplib.nix {})
    (callPackage ../dependencies/lznt1.nix {})
    yara-python
  ];

  meta = {
    description = "A configuration and module extractor for the donut binary obfuscator";
    homepage = "https://github.com/volexity/donut-decryptor";
    maintainers = [ "bsendpacket" ];
  };
}
