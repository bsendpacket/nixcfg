{ lib, fetchFromGitHub, python312Packages }:

let 
  rules = fetchFromGitHub {
    owner = "mandiant";
    repo = "capa-rules";
    rev = "0e2500fa8afac0957a616b7b14c7d38ee1beb588";
    hash = "sha256-/tbPRejnexWgzJK+eX+JdXH62SLtmOPIACF4sSCL4EA=";
  };
in
python312Packages.buildPythonApplication {
  pname = "capa";
  version = "7.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "capa";
    rev = "f69fabc2b0e776083d74fe2a7d64829ac2cb6209";
    hash = "sha256-zONYNulc7i1xFjWtAYSMappvbq+qe8yi3iRCAEzvM3k=";
  };

  nativeBuildInputs = with python312Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = with python312Packages; [
    (callPackage ../dependencies/ida-settings.nix {})
    (callPackage ../dependencies/dncil.nix {})
    (callPackage ../dependencies/networkx-3_1.nix {}) # Version on NixPkgs is 3.3, need 3.1

    tqdm
    pyyaml
    tabulate
    colorama
    termcolor
    wcwidth
    ruamel-yaml
    pefile
    pyelftools
    pydantic
    rich
    humanize
    msgspec
    vivisect
    viv-utils
    dnfile
    python-flirt
    protobuf5
  ];

  postInstall = ''
    mkdir -p $out/sigs
    cp -r sigs/* $out/sigs/

    mkdir -p $out/rules
    cp -r ${rules}/* $out/rules/

    wrapProgram $out/bin/capa \
      --add-flags "--signatures $out/sigs --rules $out/rules"
  '';

  meta = with lib; {
    description = "The FLARE team's open-source tool to identify capabilities in executable files.";
    homepage = "https://github.com/mandiant/capa";
    license = licenses.asl20;
    maintainers = [ "bsendpacket" ];
  };
}
