let
  channels = {
    nixpkgs-stable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
      sha256 = "0j15vhfz4na8wmvp532jya81y06g74qkr25ci58dp895bw7l9g2q";
    }) {
      system = "x86_64-linux";
      overlays = with overlays; [ pythonInterpreterOverlay ];
      config.allowUnfree = true;
    };

    nixpkgs-unstable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "1wn29537l343lb0id0byk0699fj0k07m1n2d7jx2n0ssax55vhwy";
    }) {
      system = "x86_64-linux";
        overlays = with overlays; [ 
          pythonPackagesOverlay 
          pinPackagesToStableOverlay 
          patchPackagesOverlay 
          homeManagerPinOverlay
          nixglOverlay
        ];
        
      config.allowUnfree = true;
      config.packageOverrides = pkgs: {
        nur = channels.nur;
      };
    };

    home-manager = (builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
      sha256 = "1lfjr640fkb7152djxvy2db1g9fqxj5hfrgjgri9b21xn3nq7992";
    });

    # NUR and nixvim overlays
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      sha256 = "0mdavhf8ing8f7s928xs796k2s1c64awh8cyv0gidj6k1zbcywq6";
    }) { pkgs = channels.nixpkgs-unstable; };

    nixvim = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixvim/archive/main.tar.gz";
      sha256 = "0ww9hmimkfmnxj9ji8ik4s1rkidjfkwg4vxfrqmfrrqd8rpij3c1";
    });
  };

  overlays = {
    # By default, if we attempt to use a Python package from Stable, while using Unstable's Python
    # We will end up with a hash collision. 
    #
    # This is because there will be 2 versions of Python installed 
    # (it can actually be the same version but different hash)
    #
    # By pinning Stable's Python to Unstable's Python, 
    # the build process and subsequent Python packages will not cause this hash collision.
    pythonInterpreterOverlay = self: super: {
      python312 = channels.nixpkgs-unstable.python312;
    };

    # Some packages are broken in unstable, use the stable versions instead
    pinPackagesToStableOverlay = self: super: {
      contour = channels.nixpkgs-stable.contour;
    };

    # This overlay is to pin Home-Manager's src to a specific hash
    homeManagerPinOverlay = self: super: {
      home-manager = super.home-manager.overrideAttrs (oldAttrs: {
        src = channels.home-manager;
      });
    };

    # This overlay is for when a package exists on NixPkgs, but a custom patch is required
    patchPackagesOverlay = self: super: {

      # Innoextract with custom patch to allow for extracting CompiledCode.bin file
      innoextract = super.innoextract.overrideAttrs (oldAttrs: {
        version = "1.10-dev-patched";

        src = channels.nixpkgs-unstable.fetchFromGitHub {
          owner = "dscharrer";
          repo = "innoextract";
          rev = "264c2fe6b84f90f6290c670e5f676660ec7b2387";
          hash = "sha256-DLQ1gphCr4haaBppAJh+zyg0ObjHzO9xLFgHpRb1f0Y=";
        };
        
        patches = [ ./innoextract/extract_compiled_code.patch ];
      });
    };

    # Fix Python package issues
    pythonPackagesOverlay = self: super: {
      python312Packages = super.python312Packages.override {
        overrides = pythonSelf: pythonSuper: {

          # The NixPkg for angr uses protobuf4, although it works with protobuf5
          # By forcing protobuf5 here, conflicts of multiple versions existing is prevented
          protobuf = pythonSuper.protobuf5;

          # Stable unicorn is required for angr at the moment
          unicorn = channels.nixpkgs-stable.python312Packages.unicorn;

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

          # Fix version mismatch on NixPkgs Unstable and suppress broken state
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
  };

  nixglOverlay = self: super: {
    nixGL = super.callPackage (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixGL/archive/main.tar.gz";
      sha256 = "1crnbv3mdx83xjwl2j63rwwl9qfgi2f1lr53zzjlby5lh50xjz4n";
    }) {};
  };
in {
  channels = channels;
}
