let
  # Detected at evaluation time so the same config works on
  # aarch64-darwin, x86_64-darwin and x86_64-linux.
  system = builtins.currentSystem;

  channels = {
    # Pinned older Yazi. Yazi renamed its `manager` config section to `mgr`
    # in later releases; staying on this pin keeps yazi/yazi.nix valid.
    nixpkgs-unstable-feb-2025 = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/df251e20548ee2ee060ac4f43c4d52fafc62d695.tar.gz";
      sha256 = "sha256-NRLlc2l8v72H2mcj9cY9KMym1BFiweimzr/2X0y3PQ0=";
    }) {
      inherit system;
      config.allowUnfree = true;
    };

    nixpkgs-unstable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/201c9d5bf2996f95d635545364614ad27262b525.tar.gz";
      sha256 = "sha256-NbqeppjwBFamZ80XAPTuB8KesUIQytcu9+plXUvTPDg=";
    }) {
      inherit system;
      overlays = with overlays; [
        homeManagerPinOverlay
      ];

      config = {
        allowUnfree = true;
      };
    };

    home-manager = (builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/7296022150cd775917e4c831c393026eae7c2427.tar.gz";
      sha256 = "sha256-9wQpgBRW2PzYw1wx+MgCt1IbPAYz93csApLMgSZOJCk=";
    });

    nixvim = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixvim/archive/24d2ac2373598c032f37d70c46803feefd169084.tar.gz";
      sha256 = "sha256-fuaDQWenfWv2HmlDUPTbfjaKSSBpwvjiQqoE0XN8tWA=";
    });
  };

  overlays = {
    # Pin Home-Manager's src to the hash fetched above, so the `home-manager`
    # binary and the modules evaluated by home.nix always agree.
    homeManagerPinOverlay = final: prev: {
      home-manager = prev.home-manager.overrideAttrs (oldAttrs: {
        src = channels.home-manager;
      });
    };
  };

in {
  channels = channels;
}
