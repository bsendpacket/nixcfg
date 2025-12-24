{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  rustPlatform,
  poetry-core,
  asttokens,
  click,
  datasets,
  huggingface-hub,
  matplotlib,
  networkx,
  numpy,
  pydot,
  requests,
  rich,
  seqeval,
  tokenizers,
  torch,
  tqdm,
  transformers,
  xdis,
}:

let
  tokenizers-pinned = tokenizers.overridePythonAttrs (prev: rec {
    version = "0.20.3";
    src = fetchFromGitHub {
      owner = "huggingface";
      repo = "tokenizers";
      tag = "v${version}";
      hash = "sha256-NPH++kPPaSPR3jm6mfh+4aep6stj0I4bA24kFtaJSKU=";
    };

    sourceRoot = "${src.name}/bindings/python";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit version src sourceRoot;
      pname = prev.pname;
      hash = "sha256-9JcstMp3wQJ7OH5LCbtdfRN6KHP9R93uZ3ssEytRzP4=";
    };
  });

  transformers-pinned = (transformers.override {
    tokenizers = tokenizers-pinned;
  }).overridePythonAttrs (_: rec {
    version = "4.46.1";
    src = fetchFromGitHub {
      owner = "huggingface";
      repo = "transformers";
      tag = "v${version}";
      hash = "sha256-lVpzOjBb92EZpNLSPBSWrpkENgdovCDSoMp6R13nzsM=";
    };
  });
in
  buildPythonApplication {
    pname = "pylingual";
    version = "unstable-2025-09-16";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "syssec-utd";
      repo = "pylingual";
      rev = "9f0ba2aa0195ce853b65e1064e8aaae09b67966f";
      hash = "sha256-aeKYXKTAjh0aY6/AIyCvY/t70RTZUekfaBEIb4eGhqU=";
    };

    build-system = [
      poetry-core
    ];

    dependencies = [
      transformers-pinned
      tokenizers-pinned
      asttokens
      click
      datasets
      huggingface-hub
      matplotlib
      networkx
      numpy
      pydot
      requests
      rich
      seqeval
      torch
      tqdm
      xdis
    ];

    pythonImportsCheck = [
      "pylingual"
    ];

    meta = {
      description = "Python decompiler for modern Python versions";
      homepage = "https://github.com/syssec-utd/pylingual";
      license = lib.licenses.gpl3Only;
      maintainers = [ ];
      mainProgram = "pylingual";
    };
  }
