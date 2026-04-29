{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage {
  pname = "chaskey-lts";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "volexity";
    repo = "chaskey-lts";
    rev = "85d3c85fadda24cd9c8d86fe80f5effc7da85390";
    hash = "sha256-sxrdLTml6R0r563VwtgUMOAX18kIbN5LkRT2bw/3QsU=";
  };

  pyproject = true;
  build-system = [ hatchling hatch-vcs ];

  meta = {
    description = "A pure Python chaskey cipher implementation developed initially for use with the donut_decryptor.";
    homepage = "https://github.com/volexity/chaskey-lts";
    maintainers = [ ];
  };
}
