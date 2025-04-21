{ channels, binaryNinjaURL }:
let

  pythonWithPackages = channels.nixpkgs-unstable.python312.withPackages (ps: with channels.nixpkgs-unstable.python312Packages; [
    rpyc
    lxml
    httpx
    qiling
    requests
    z3-solver
    flatbuffers

    (callPackage ./binary-ninja-api.nix {
      binaryNinjaUrl  = binaryNinjaURL.binaryNinjaUrl;
      binaryNinjaHash = binaryNinjaURL.binaryNinjaHash;
    })

    (callPackage ../dependencies/triton.nix { 
      z3 = channels.nixpkgs-unstable.z3;
      boost = channels.nixpkgs-unstable.boost;
      libffi = channels.nixpkgs-unstable.libffi;
      libxml2 = channels.nixpkgs-unstable.libxml2;
      bitwuzla = channels.nixpkgs-unstable.bitwuzla;
      capstone = channels.nixpkgs-unstable.capstone;
      llvmPackages_16 = channels.nixpkgs-unstable.llvmPackages_16;
    })

    (callPackage ../dependencies/pysqlite3.nix {})
    (callPackage ../dependencies/mkyara.nix {})
    (callPackage ../dependencies/icicle-emu.nix {})
    (callPackage ../binary-refinery/binary-refinery.nix {})
  ]); 

  fetchBinaryNinjaPlugin = { name, folder ? "", sha256, url ? null, 
    owner ? null, repo ? null, rev ? null, pluginPath ? ""
  }: 
    channels.nixpkgs-unstable.stdenv.mkDerivation {
      inherit name;
      
      src = if url != null 
        then channels.nixpkgs-unstable.fetchzip {
          inherit url sha256;
          stripRoot = false;
        }
        else channels.nixpkgs-unstable.fetchFromGitHub {
          inherit owner repo rev sha256;
        };

      installPhase = ''
        mkdir -p $out/.binaryninja/plugins${if folder != "" then "/${folder}" else ""}
        ${if pluginPath != "" then ''
          cp ${pluginPath} $out/.binaryninja/plugins/
        '' else ''
          cp -r . $out/.binaryninja/plugins/${folder}
        ''}
      '';
    };

  plugins = [
    # HashDB Plugin
    (fetchBinaryNinjaPlugin {
      owner = "cxiao";
      repo = "hashdb_bn";
      rev = "cc5ef77c78b929aeee13ae0fcb02d0db2218fe62";
      sha256 = "sha256-MgMICkc3c1ynINZOQB7WUvkr/1B5RQTaVTM3xpKb5+s=";
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

    (fetchBinaryNinjaPlugin {
      owner = "Vector35";
      repo = "snippets";
      rev = "130636ae51c1cacc901e72f63941cbe904087cb6";
      sha256 = "sha256-V3jOm8z0HUfBeUeHkMfOlAVIlzyS9XcZLkUKmGEdxl4=";
      name = "binja_snippets";
      folder = "binja_snippets";
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

    # Apply COM interface information
    (fetchBinaryNinjaPlugin {
      owner = "Vector35";
      repo = "COMpanion";
      rev = "32dfb4c71bbd5ee998831b224b8506d0643dba24";
      sha256 = "sha256-FX1gGLvGHpPVz230I06S1goWiFQhqR8UV0p4GAkqOPE=";
      name = "COMpanion";
      folder = "COMpanion";
    })

    # Semi-headless setup for Binja
    (fetchBinaryNinjaPlugin {
      owner = "hugsy";
      repo = "binja-headless";
      rev = "7d9acc2874c574ecd528c45ab69715268ec2504e";
      sha256 = "sha256-PXVwN59jbUiRJFz5v/cHdAd3QK0C/OCGL/BERg2WZwY=";
      name = "binja_headless";
      folder = "binja_headless";
    })

    (fetchBinaryNinjaPlugin {
      owner = "notpidgey";
      repo = "iemu";
      rev = "f34a92d5c4031cca12bf492599353693caa8c982";
      sha256 = "sha256-1p+FO9KEXe8pBxWuwudZps4eorSA5zogz9Kruou8/nU=";
      name = "iemu";
      folder = "iemu";
    })

    (fetchBinaryNinjaPlugin {
      owner = "borzacchiello";
      repo = "seninja";
      rev = "f8da9abc318755d0ff23e584d51a35734920839c";
      sha256 = "sha256-da9QN4tViBeICPc6E0QYKLHgHv+vhzEsQ5XlmB53JJQ=";
      name = "seninja";
      folder = "seninja";
    })

    (fetchBinaryNinjaPlugin {
      owner = "Vector35";
      repo = "OpaquePredicatePatcher";
      rev = "4458f6340ef1f363bcefa1c0705d63b3ed94cec2";
      sha256 = "sha256-HOzP4HHBM+0toabMhcPdLzPwZu+3xsaLYZhs0P6yxfE=";
      name = "OpaquePredicatePatcher";
      folder = "OpaquePredicatePatcher";
    })

    (fetchBinaryNinjaPlugin {
      owner = "cxiao";
      repo = "rust_string_slicer";
      rev = "0d611a38a19a46d924a176dcc481230dd3129afc";
      sha256 = "sha256-lh65g/eaGrT6DIpa9Y72j2JaWwYlBG1eyzAeMnvauZ0=";
      name = "rust_string_slicer";
      folder = "rust_string_slicer";
    })

    # TODO: Figure out how to build this manually since the ABI used to build the plugin is outdated..
    # (fetchBinaryNinjaPlugin {
    #   name = "binexport";
    #   url = "https://github.com/google/binexport/releases/download/v12-20240417-ghidra_11.0.3/BinExport-Linux.zip";
    #   sha256 = "sha256-U59WFcICyW19yx0PWIYvzvremP/gnx2liHXByVNRLZ8=";
    #   pluginPath = "binaryninja/binexport12_binaryninja.so";
    # })
  ];

  binaryNinjaConfigFiles = channels.nixpkgs-unstable.stdenv.mkDerivation {
    name = "binary-ninja-config-files";
    src = ./config;
    buildInputs = [ channels.nixpkgs-unstable.coreutils ];
    installPhase = ''
      mkdir -p $out/.binaryninja
      cp -r * $out/.binaryninja/
      mkdir -p $out/.binaryninja/plugins
      ${channels.nixpkgs-unstable.lib.concatMapStrings (plugin: ''
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
