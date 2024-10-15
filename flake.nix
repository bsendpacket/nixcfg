{
  description = "0x1c Home-Manager Malware Analysis Setup";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, nur, home-manager, nixvim }:
    let
      username = "twentyeight";
      homeDirectory = "/home/twentyeight";
      isNixOS = builtins.pathExists "/etc/NIXOS";

      # Overlays
      pythonOverlay = self: super: {
        python312Packages = super.python312Packages.override {
          overrides = pythonSelf: pythonSuper: {
            # Override protobuf to use version 5
            protobuf = pythonSuper.protobuf5;

            # Override angr-related dependencies
            pyvex = pythonSuper.pyvex.overrideAttrs (oldAttrs: rec {
              version = "9.2.120";

              src = pythonSelf.fetchPypi {
                pname = "pyvex";
                version = version;
                sha256 = "sha256-pMGjUHGu/cxFqQb0It8/ZRzy+l3zJ0r8vsCO5TMbvrY=";
              };
            });

            archinfo = pythonSuper.archinfo.overrideAttrs (oldAttrs: rec {
              version = "9.2.120";

              src = pythonSelf.fetchPypi {
                pname = "archinfo";
                version = version;
                sha256 = "sha256-zlXHn9sXqA460dOAjnq6tEaIsKPU/nh+IKHCPX9RVhY=";
              };
            });

            claripy = pythonSuper.claripy.overrideAttrs (oldAttrs: rec {
              version = "9.2.120";

              src = pythonSelf.fetchPypi {
                pname = "claripy";
                version = version;
                sha256 = "sha256-DTX7ktnreH4d8J+7e+vutZbvClxO4Hb4NuicM+enZjY=";
              };
            });

            cle = pythonSuper.cle.overrideAttrs (oldAttrs: rec {
              version = "9.2.120";

              src = pythonSelf.fetchPypi {
                pname = "cle";
                version = version;
                sha256 = "sha256-FJ2nt3krfY8y24cukto3KeQrq6mJHJMiK9WEe4R65Wo=";
              };
            });

            ailment = pythonSuper.ailment.overrideAttrs (oldAttrs: rec {
              version = "9.2.120";

              src = pythonSelf.fetchPypi {
                pname = "ailment";
                version = version;
                sha256 = "sha256-B5aSEQYs3B6RzlQmkOeEnvdgrkSDlJIFC+KHU4eN/6k=";
              };
            });

            angr = pythonSuper.angr.overrideAttrs (oldAttrs: rec {
              version = "9.2.120";

              src = pythonSelf.fetchPypi {
                pname = "angr";
                version = version;
                sha256 = "sha256-CGHE2sJVPlAJ6mBcmtuR3k7MvMBkBgppOH4tVPmewuA=";
              };

              meta = oldAttrs.meta // {
                broken = false;
              };
            });
          };
        };
      };

      customOverlay = self: super: {
        innoextract = super.innoextract.overrideAttrs (oldAttrs: {
          version = "1.10-dev-patched";

          src = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux".fetchFromGitHub {
            owner = "dscharrer";
            repo = "innoextract";
            rev = "264c2fe6b84f90f6290c670e5f676660ec7b2387";
            hash = "sha256-DLQ1gphCr4haaBppAJh+zyg0ObjHzO9xLFgHpRb1f0Y=";
          };

          patches = [ ./innoextract/extract_compiled_code.patch ];
        });
      };

      # Combine overlays
      overlays = [ pythonOverlay customOverlay nur.overlay ];

      # Import package sets with overlays
      nixpkgs-stable = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        overlays = overlays;
        config.allowUnfree = true;
      };

      nixpkgs-unstable = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        overlays = overlays;
        config.allowUnfree = true;
      };

    in {
      homeConfigurations = {
        twentyeight = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable;

          modules = [
            ./home.nix
          ];

          extraSpecialArgs = {
            inherit nixpkgs-stable nixpkgs-unstable nur nixvim username homeDirectory isNixOS;
          };
        };
      };
    };
}

