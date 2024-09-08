{ pkgs }:
let
  pythonWithPackages = pkgs.python312.withPackages (ps: with ps; [
    requests
    (callPackage ../dependencies/mkyara.nix {})
  ]); 
  fetchBinaryNinjaPlugin = { owner, repo, rev ? "main", name, sha256 }: 
    pkgs.stdenv.mkDerivation {
      inherit name;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
      installPhase = ''
        mkdir -p $out/.binaryninja/plugins/
        cp -r . $out/.binaryninja/plugins/
      '';
    };
  # List of plugins to install
  plugins = [
    (fetchBinaryNinjaPlugin {
      owner = "Donaldduck8";
      repo = "binary-ninja-plugins";
      rev = "d148388ce513f27e3a70e3da899e52a987f3ad2f";
      sha256 = "sha256-ZVRCmud+YHxn1fCMRBfQMGMFQfYliS29CiiGEuiy5sE=";
      name = "plugins";
    })
    # Add more plugins here as needed
  ];
  binaryNinjaConfigFiles = pkgs.stdenv.mkDerivation {
    name = "binary-ninja-config-files";
    src = ./config; # Assuming your config files are in a 'config' directory
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
