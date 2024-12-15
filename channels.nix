let
  channels = {
    nixpkgs-stable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/c0b1da36f7c34a7146501f684e9ebdf15d2bebf8.tar.gz";
      sha256 = "0j15vhfz4na8wmvp532jya81y06g74qkr25ci58dp895bw7l9g2q";
    }) {
      system = "x86_64-linux";
      overlays = with overlays; [ pythonInterpreterOverlay ];
      config.allowUnfree = true;
    };

    nixpkgs-unstable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/5a48e3c2e435e95103d56590188cfed7b70e108c.tar.gz";
      sha256 = "0qgiha64bncgy711c9ym94k34ki4lc90p739g3qmf9warqp8fa67";
    }) {
      system = "x86_64-linux";
        overlays = with overlays; [ 
          pinPackagesToSpecificVersionOverlay
          pythonPackagesOverlay 
          pinPackagesToStableOverlay 
          patchPackagesOverlay 
          homeManagerPinOverlay
          nixglOverlay
        ];
        
      config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          nur = channels.nur;
        };
        # TEMPORARY
        permittedInsecurePackages = [
          "dotnet-sdk-6.0.428"
          "dotnet-runtime-6.0.36"
        ];
      };
    };

    home-manager = (builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/66c5d8b62818ec4c1edb3e941f55ef78df8141a8.tar.gz";
      sha256 = "0bn15l9rnzqihmyhzx0dg1l0v5wg646wqrspjgnd1d8rjwd20b45";
    });

    # NUR and nixvim overlays
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/12bcdb7c86a2598761a7e2ada1b1e6cd7542197c.tar.gz";
      sha256 = "1ncwyc8fzw317gzagkfda28rk1f1ws7pnk4363zds1rpp0cls2rx";
    }) { pkgs = channels.nixpkgs-unstable; };

    nixvim = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixvim/archive/58d2a5ac9cc4ff987e6edb77f2b55d1dec05ce50.tar.gz";
      sha256 = "0sk5njshf9pbr44bfpgvc3fv2a1xznhj763gwlrgwlwmn14z17dy";
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

    pinPackagesToSpecificVersionOverlay = self: super: {
      unicorn = super.unicorn.overrideAttrs (oldAttrs: {
        src = super.fetchFromGitHub {
          owner = "unicorn-engine";
          repo = "unicorn";
          rev = "2.0.1.post1";
          hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
        };
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

          # Unicorn v2.0.1 still requires setuptools+distutils
          unicorn = pythonSuper.unicorn.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = with super.python312Packages; [ setuptools distutils ];
          });

          # Suppress broken state as the version of Unicorn is correctly pinned
          angr = pythonSuper.angr.overrideAttrs (oldAttrs: {
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
      url = "https://github.com/nix-community/nixGL/archive/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a.tar.gz";
      sha256 = "1crnbv3mdx83xjwl2j63rwwl9qfgi2f1lr53zzjlby5lh50xjz4n";
    }) {};
  };
in {
  channels = channels;
}
