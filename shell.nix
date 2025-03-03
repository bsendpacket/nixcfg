{}:
let
  channels = (import ./channels.nix).channels;
in
  channels.nixpkgs-unstable.mkShell {
    buildInputs = [
      channels.nixpkgs-unstable.home-manager
    ];

    shellHook = ''
      export NIX_PATH="nixpkgs=${channels.nixpkgs-unstable.path}:$NIX_PATH"

      echo "Shell for Home Manager is now ready!"
      echo "Use 'home-manager switch' to install the configuration."
    '';
  }

