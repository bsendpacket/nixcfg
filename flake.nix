{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/f13bdef0bc697261c51eab686c28c7e2e7b7db3c";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, nixvim, ... }:
    let
      system = "x86_64-linux";
      homeDirectory = builtins.getEnv "HOME";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixgl.overlay
        ];
        config.allowUnfree = true;
      };

      mkHomeConfiguration = username: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "23.11";
            };
            programs.nixvim = import ./neovim/neovim.nix { inherit pkgs homeDirectory; };
          }
        ];
        extraSpecialArgs = {
          inherit nixgl;
          inherit nixvim;
        };
      };
    in {
      homeConfigurations = {
        twentyeight = mkHomeConfiguration "twentyeight";
        bsendpacket = mkHomeConfiguration "bsendpacket";
      };

      apps.${system}.default = {
        type = "app";
        program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
      };
    };
}
