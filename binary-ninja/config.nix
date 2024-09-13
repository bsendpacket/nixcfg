{ pkgs }:
let
  pythonWithPackages = pkgs.python312.withPackages (ps: with ps; [
    requests
    lxml
    httpx
    flatbuffers
    (callPackage ../dependencies/mkyara.nix {})
  ]); 
  fetchBinaryNinjaPlugin = { owner, repo, rev ? "main", name, sha256, folder ? "" }: 
    pkgs.stdenv.mkDerivation {
      inherit name;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
      installPhase = ''
        mkdir -p $out/.binaryninja/plugins/${folder}
        cp -r . $out/.binaryninja/plugins/${folder}
      '';
    };

  plugins = [
    # HashDB Plugin
    (fetchBinaryNinjaPlugin {
      owner = "cxiao";
      repo = "hashdb_bn";
      rev = "b257b83d806b856029ae0452e303d5a8cac03682";
      sha256 = "sha256-squ8PAD43uM4u9CulIalzONIEMqSBkz43u9CTWeL8Wc=";
      name = "hashdb";
      folder = "hashdb";
    })

    # Add gocall calling convention
    (fetchBinaryNinjaPlugin {
      owner = "PistonMiner";
      repo = "binaryninja-go-callconv";
      rev = "a7cb661b111ed7f89361126a3b1d95e3f1cd02c2";
      sha256 = "sha256-ZHrQMt2mkqbD+m9hgWhWuIeWWqBtDEZ2l/8Gut3karE=";
      name = "binaryninja_go_callconv";
      folder = "binaryninja_go_callconv";
    })

    # YARA Helper
    (fetchBinaryNinjaPlugin {
      owner = "Donaldduck8";
      repo = "binary-ninja-plugins";
      rev = "d148388ce513f27e3a70e3da899e52a987f3ad2f";
      sha256 = "sha256-ZVRCmud+YHxn1fCMRBfQMGMFQfYliS29CiiGEuiy5sE=";
      name = "copy_as_yara";
    })

    # Import GoReSym JSON data to populate Binja
    (fetchBinaryNinjaPlugin {
      owner = "xusheng6";
      repo = "binja-GoReSym";
      rev = "bc7aaa8dd8e0904c8eca14d35b5613bba9228b0a";
      sha256 = "sha256-sA6N2keS6RXzO/wcItjgbVr5TuHNc7wPCNMRhHStgjo=";
      name = "binja_goresym";
      folder = "binja_goresym";
    })

    # IDA-style Python console
    (fetchBinaryNinjaPlugin {
      owner = "CouleeApps";
      repo = "hex_integers";
      rev = "4191900686568469546126469179206662254674";
      sha256 = "sha256-bl5wc4Nnnl9z5nM8Giq9FVVx0n6HLIeP7PDZFeR/FP8=";
      name = "hex_integers";
      folder = "hex_integers";
    })

    # Lookup MSDN docs with Ctrl-q / Ctrl-Q
    (fetchBinaryNinjaPlugin {
      owner = "riskydissonance";
      repo = "binja-doc-lookup";
      rev = "3883b41514ba9966427c57c0847fe5e12ef5d583";
      sha256 = "sha256-+81wY/qXVtTrFQoYKhKHsKTfo4Efui2AkpBHGC6PXBg=";
      name = "binja_doc_lookup";
      folder = "binja_doc_lookup";
    })

    # Create and load .sig files
    (fetchBinaryNinjaPlugin {
      owner = "Vector35";
      repo = "sigkit";
      rev = "a7420964415a875a1e6181ecdc603cfc29e34058";
      sha256 = "sha256-A7EcsOpnYL6SNJJhCL+tITGmxyHgI6MjGRbosmJHt9w=";
      name = "sigkit";
      folder = "sigkit";
    })

  ];
  binaryNinjaConfigFiles = pkgs.stdenv.mkDerivation {
    name = "binary-ninja-config-files";
    src = ./config;
    buildInputs = [ pkgs.coreutils ];
    installPhase = ''
      mkdir -p $out/.binaryninja
      cp -r * $out/.binaryninja/
      mkdir -p $out/.binaryninja/plugins
      ${pkgs.lib.concatMapStrings (plugin: ''
        cp -r ${plugin}/.binaryninja/plugins/* $out/.binaryninja/plugins/
      '') plugins}
    '';
  };
in
{
  pythonEnv = pythonWithPackages;
  binaryNinjaConfig = {
    home.file.".binaryninja" = {
      source = "${binaryNinjaConfigFiles}/.binaryninja";
      recursive = true;
    };
  };
}
