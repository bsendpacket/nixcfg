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
      url = "https://github.com/NixOS/nixpkgs/archive/807e9154dcb16384b1b765ebe9cd2bba2ac287fd.tar.gz";
      sha256 = "1xc6bw4sa7bq34rinmbmz0rdnbr0lan5xvk53kbcjkyc8p1pfvlp";
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
        
      config.allowUnfree = true;
      config.packageOverrides = pkgs: {
        nur = channels.nur;
      };
    };

    home-manager = (builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/2a4fd1cfd8ed5648583dadef86966a8231024221.tar.gz";
      sha256 = "1lfjr640fkb7152djxvy2db1g9fqxj5hfrgjgri9b21xn3nq7992";
    });

    # NUR and nixvim overlays
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/27913565fdb9db9c0f078aa36ccfab943a777ae3.tar.gz";
      sha256 = "1d156ninl270mgy5ix89mx08qmk151ivxnr9c2m05ssi3l9wqx2s";
    }) { pkgs = channels.nixpkgs-unstable; };

    nixvim = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixvim/archive/42ea1626cb002fa759a6b1e2841bfc80a4e59615.tar.gz";
      sha256 = "0ajfx35h4z3814p2cpbz4yh0ds948h9x8kgv7kbqnjjjlh72jgp7";
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
