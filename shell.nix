{ pkgs ? import <nixpkgs> {} }:
let
  channels = (import ./channels.nix).channels;
  home-manager = channels.nixpkgs-unstable.home-manager.overrideAttrs (oldAttrs: {
    src = channels.home-manager;
  });
in
  pkgs.mkShell {
    buildInputs = [
      home-manager
    ];

    shellHook = ''
      export NIX_PATH="nixpkgs=${channels.nixpkgs-unstable.path}:$NIX_PATH"

      echo "Shell for Home Manager is now ready!"
      echo "Use 'home-manager switch' to install the configuration."
    '';
  }

