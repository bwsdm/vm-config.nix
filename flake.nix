{
  description = "Example kickstart NixOS desktop environment.";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    nixvim,
    ...
  }: let
    nixos-system = import ./system/nixos.nix {
      inherit inputs;
      username = "bwsdm"; # TODO: replace with user name and remove throw
      password = ""; # TODO: replace with password and remove throw

    };
  in {
    nixosConfigurations = {
      x86_64 = nixos-system "x86_64-linux";
    };

  };
}
