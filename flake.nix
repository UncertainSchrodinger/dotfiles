{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url =  "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helper for managing tmux layouts. It's a monorepo and this allows me to
    # pull just one project from a subdirectory.
    rojekti = {
      url = "github:UncertainSchrodinger/molokki?dir=rojekti";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }: {

    packages."x86_64-linux" = let
      legacyPackages = nixpkgs.legacyPackages."x86_64-linux";
    in
    rec {
      cosmocc = legacyPackages.callPackage ./pkgs/cosmocc.nix { };
      llamafile = legacyPackages.callPackage ./pkgs/llamafile.nix { cosmocc = cosmocc; };
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self; inherit inputs; };
      modules = [
        ./machines/kuglimon-desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/kuglimon-desktop/home.nix];
          };
        }
      ];
    };

    nixosConfigurations.sheridan = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self; inherit inputs; };
      modules = [
        ./machines/sheridan-virtualbox/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/sheridan-virtualbox/home.nix];
          };
        }
      ];
    };

    nixosConfigurations.watermedia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self; inherit inputs; };
      modules = [
        ./machines/watermedia-elitedesk/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/watermedia-elitedesk/home.nix];
          };
        }
      ];
    };

    darwinConfigurations.lorien = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./machines/lorien-macbookpro-2017/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kuglimon = { ... } :{
            imports = [./machines/lorien-macbookpro-2017/home.nix];
          };
        }
      ];
    };
  };
}
