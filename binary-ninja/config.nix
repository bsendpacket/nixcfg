{ channels, binaryNinjaURL }:
let

  pythonWithPackages = channels.nixpkgs-unstable-upstream.python312.withPackages (ps: with channels.nixpkgs-unstable-upstream.python312Packages; [
    rpyc
    lxml
    httpx
    miasm
    # qiling
    requests
    z3-solver
    flatbuffers

    (ps.callPackage ./binary-ninja-api.nix {
      binaryNinjaUrl  = binaryNinjaURL.binaryNinjaUrl;
      binaryNinjaHash = binaryNinjaURL.binaryNinjaHash;
    })

    # (ps.callPackage ../dependencies/triton.nix { 
    #   z3 = channels.nixpkgs-unstable.z3;
    #   boost = channels.nixpkgs-unstable.boost;
    #   libffi = channels.nixpkgs-unstable.libffi;
    #   libxml2 = channels.nixpkgs-unstable.libxml2;
    #   bitwuzla = channels.nixpkgs-unstable.bitwuzla;
    #   capstone = channels.nixpkgs-unstable.capstone;
    #   llvmPackages_16 = channels.nixpkgs-unstable.llvmPackages_16;
    # })

    (ps.callPackage ../dependencies/pysqlite3.nix {})
    (ps.callPackage ../dependencies/msynth.nix {})
    (ps.callPackage ../dependencies/mkyara.nix {})
    # (ps.callPackage ../dependencies/icicle-emu.nix {})
    (ps.callPackage ../binary-refinery/binary-refinery.nix {})
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
      rev = "eb0ab0585135a6812cce7d793d54fdf05f19dd49";
      sha256 = "sha256-lfrHRgPTepl0P98GsLKqY30i5ElSH/PDEm6faVeFrEc=";
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

    (fetchBinaryNinjaPlugin {
      owner = "Vector35";
      repo = "snippets";
      rev = "ceb917b3f4cb895d186691beff3740d9b17b8eb9";
      sha256 = "sha256-+OIXGS4gK8LCcFegjeI9GNKGXsoEq+8l3gpQqELKoBE=";
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

    (fetchBinaryNinjaPlugin {
      owner = "withzombies";
      repo = "bnil-graph";
      rev = "534f4102caabb590c4e1fa6713630172c97bcf32";
      sha256 = "sha256-E0IkpZdUftEK1iS/vVrSH85bZtoECexhoML6TDpybz4=";
      name = "bnil-graph";
      folder = "bnil-graph";
    })

    (fetchBinaryNinjaPlugin {
      owner = "mrphrazer";
      repo = "obfuscation_detection";
      rev = "ce459c864a16bf4b36270c12ae7f985055db6df8";
      sha256 = "sha256-dRPGzBpPe4tWkpJ8GdnCYqA7/k0apcg/Bysu6/2TXZE=";
      name = "obfuscation_detection";
      folder = "obfuscation_detection";
    })
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
