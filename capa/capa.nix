{ 
  lib, 
  fetchFromGitHub, 
  buildPythonApplication, 
  setuptools, 
  setuptools-scm, 
  wheel, 
  callPackage, 
  tqdm, 
  pyyaml, 
  tabulate, 
  colorama, 
  termcolor, 
  wcwidth, 
  ruamel-yaml, 
  pefile, 
  pyelftools, 
  pydantic, 
  rich, 
  humanize, 
  msgspec, 
  vivisect, 
  viv-utils, 
  dnfile, 
  python-flirt, 
  protobuf5, 
  networkx,
  xmltodict
}:

let 
  rules = fetchFromGitHub {
    owner = "mandiant";
    repo = "capa-rules";
    rev = "7ae786cf705f9a824ba8ef6d4d8dac648c6250ca";
    hash = "sha256-LEVXdvZXo20ViRIA/fptiviITUcRAMx+8Tkuehxr3F4=";
  };
in
buildPythonApplication {
  pname = "capa";
  version = "9.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "capa";
    rev = "5a0c47419f7a1c12dd5ef644bfb6676bdcf65517";
    hash = "sha256-3JZeNa9rg5bOCjJARnkJlPo+C2+690CbadqiPYy8mpU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    (callPackage ../dependencies/ida-settings.nix {})
    (callPackage ../dependencies/dncil.nix {})

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
    networkx
    xmltodict
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
