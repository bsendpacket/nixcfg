let
  channels = {
    nixpkgs-stable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/c8aa8cc00a5cb57fada0851a038d35c08a36a2bb.tar.gz";
      sha256 = "sha256-m9W0dYXflzeGgKNravKJvTMR4Qqa2MVD11AwlGMufeE=";
    }) {
      system = "x86_64-linux";
      overlays = with overlays; [ pythonInterpreterOverlay ];
      config.allowUnfree = true;
    };

    nixpkgs-unstable-dec-2024 = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/69b9a8c860bdbb977adfa9c5e817ccb717884182.tar.gz";
      sha256 = "12ljkkjg3gicamvryxr2bnfcdb05qdlbc5wv4lcw9sxamszp4cp7";
    }) {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };

    nixpkgs-unstable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/201c9d5bf2996f95d635545364614ad27262b525.tar.gz";
      sha256 = "sha256-NbqeppjwBFamZ80XAPTuB8KesUIQytcu9+plXUvTPDg=";
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
      };
    };

    home-manager = (builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/7296022150cd775917e4c831c393026eae7c2427.tar.gz";
      sha256 = "sha256-9wQpgBRW2PzYw1wx+MgCt1IbPAYz93csApLMgSZOJCk=";
    });

    # NUR and nixvim overlays
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/e65c733fc5dd8ca716bc27ab143c065bd65f6cc4.tar.gz";
      sha256 = "sha256-KLrBBxEHIm9aduGSwxGHYlMy20z9NNXUymKnLmR8ydM=";
    }) { pkgs = channels.nixpkgs-unstable; };

    nixvim = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixvim/archive/24d2ac2373598c032f37d70c46803feefd169084.tar.gz";
      sha256 = "sha256-fuaDQWenfWv2HmlDUPTbfjaKSSBpwvjiQqoE0XN8tWA=";
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

    # If packages are broken in unstable, use the stable versions instead
    pinPackagesToStableOverlay = self: super: {
      # contour = channels.nixpkgs-stable.contour;
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

        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        ];
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
          rev = "e58f295d80c3bbd18fb01c18983855064ebc361f";
          hash = "sha256-nbemdwNnYABQb7rhJiztZdyVc2otLNfQBtPTaK+wdCY=";
        };
        
        patches = [ ./innoextract/extract_compiled_code.patch ];

        # Enable debug flags
        cmakeFlags = [
          "-DDEVELOPER=1"
          "-DCMAKE_BUILD_TYPE=Debug"
        ];
      });
    };

    # Fix Python package issues
    pythonPackagesOverlay = self: super: {
      python312Packages = super.python312Packages.override {
        overrides = pythonSelf: pythonSuper: {

          # Unicorn v2.0.1 still requires setuptools+distutils
          # unicorn = pythonSuper.unicorn.overrideAttrs (oldAttrs: {
          #   propagatedBuildInputs = with super.python312Packages; [ setuptools distutils ];
          # });

	  ## The following issues are mostly resolved, and are unnessasary now, however,
	  ## they are here for examples as to what may be required:

          # The NixPkg for angr uses protobuf4, although it works with protobuf5
          # By forcing protobuf5 here, conflicts of multiple versions existing is prevented
          # protobuf = pythonSuper.protobuf5;

          # Suppress broken state as the version of Unicorn is correctly pinned
          # angr = pythonSuper.angr.overrideAttrs (oldAttrs: {
          #  meta = oldAttrs.meta // {
          #    broken = false;
          #  };
          # });

          # Upstream currently lacks pyproject + build-system, which is required.
          # meson = pythonSuper.meson.overrideAttrs (oldAttrs: {
          #   pyproject = true;
          #   build-system = [ pythonSelf.setuptools ];
          # });
        };
      };
    };
  };

  nixglOverlay = self: super: {
    nixGL = super.callPackage (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixGL/archive/a8e1ce7d49a149ed70df676785b07f63288f53c5.tar.gz";
      sha256 = "sha256-Ob/HuUhANoDs+nvYqyTKrkcPXf4ZgXoqMTQoCK0RFgQ=";
    }) {};
  };

in {
  channels = channels;
}
