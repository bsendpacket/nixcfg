{ buildPythonApplication, fetchFromGitHub, hatchling, hatch-vcs, callPackage, yara-python }:

buildPythonApplication {
  pname = "donut-decryptor";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "volexity";
    repo = "donut-decryptor";
    rev = "4b2120aa9f6290051971e3b7fa520dfdef7e34c9";
    hash = "sha256-fyQKKGPT29sAU2uy3Vqt8YF98/sd4MZHt/Xq5/1O/o8=";
  };

  pyproject = true;
  build-system = [ hatchling hatch-vcs ];

  propagatedBuildInputs = [
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
